// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import GameplayKit

// MARK: - events

private enum UpdateEvent {
    case startUpdateRequested

    case fileLoaded, failedToLoadFile
    case destinationPathSet
    case fileSent
    case robotDisconnected
    case robotDetected
}

// MARK: - StateMachine states

private protocol StateEventProcessor {
    func process(event: UpdateEvent)
}

private class StateInitial: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateLoadingUpdateFile.Type
    }

    func process(event: UpdateEvent) {
        switch event {
            case .startUpdateRequested:
                self.stateMachine?.enter(StateLoadingUpdateFile.self)
            default:
                return
        }
    }
}

private class StateLoadingUpdateFile: GKState, StateEventProcessor {

    private var firmware: FirmwareManager

    init(firmware: FirmwareManager) {
        self.firmware = firmware
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateErrorFailedToLoadFile.Type || stateClass is StateSettingDestinationPath.Type
    }

    override func didEnter(from previousState: GKState?) {

        let isLoaded = firmware.load()

        if isLoaded {
            process(event: .fileLoaded)
        } else {
            process(event: .failedToLoadFile)
        }
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileLoaded:
                self.stateMachine?.enter(StateSettingDestinationPath.self)
            case .failedToLoadFile:
                self.stateMachine?.enter(StateErrorFailedToLoadFile.self)
            default:
                return
        }
    }
}

private class StateSettingDestinationPath: GKState, StateEventProcessor {

    private var firmware: FirmwareManager
    private var robot: RobotPeripheralViewModel

    init(firmware: FirmwareManager, robot: RobotPeripheralViewModel) {
        self.firmware = firmware
        self.robot = robot
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateSendingFile.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("StateSettingDestinationPath")  // TODO: set BLE destination path and clear file
        process(event: .destinationPathSet)  // TODO: remove when todo above is done
    }

    func process(event: UpdateEvent) {
        switch event {
            case .destinationPathSet:
                self.stateMachine?.enter(StateSendingFile.self)
            default:
                return
        }
    }
}

private class StateSendingFile: GKState, StateEventProcessor {

    private var firmware: FirmwareManager
    private var robot: RobotPeripheralViewModel

    init(firmware: FirmwareManager, robot: RobotPeripheralViewModel) {
        self.firmware = firmware
        self.robot = robot
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateApplyingUpdate.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("StateSendingFile")  // TODO: send file
        process(event: .fileSent)  // TODO: remove when todo above is done
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileSent:
                self.stateMachine?.enter(StateApplyingUpdate.self)
            default:
                return
        }
    }
}

private class StateApplyingUpdate: GKState, StateEventProcessor {

    private var firmware: FirmwareManager
    private var robot: RobotPeripheralViewModel

    init(firmware: FirmwareManager, robot: RobotPeripheralViewModel) {
        self.firmware = firmware
        self.robot = robot
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateWaitingForRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("StateApplyingUpdate")  // TODO: set BLE major, minor and revision apply
        process(event: .robotDisconnected)  // TODO: remove when todo above is done
    }

    func process(event: UpdateEvent) {
        switch event {
            case .robotDisconnected:
                self.stateMachine?.enter(StateWaitingForRobotToReboot.self)
            default:
                return
        }
    }
}

private class StateWaitingForRobotToReboot: GKState, StateEventProcessor {

    private var robot: RobotPeripheralViewModel

    init(robot: RobotPeripheralViewModel) {
        self.robot = robot
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateFinal.Type || stateClass is StateErrorRobotNotUpToDate.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("StateWaitingForRobotToReboot")  // TODO: remove when robotDisconnected implemented
        process(event: .robotDetected)  // TODO: remove when todo above is done
    }

    func process(event: UpdateEvent) {
        let isRobotUpToDate = Bool.random()  // TODO: check robot is up to date

        switch event {
            case .robotDetected:
                if isRobotUpToDate {
                    self.stateMachine?.enter(StateFinal.self)
                } else {
                    self.stateMachine?.enter(StateErrorRobotNotUpToDate.self)
                }
            default:
                return
        }
    }
}

private class StateFinal: GKState {}

// MARK: - StateMachine error states

private protocol StateError {}

private class StateErrorFailedToLoadFile: GKState, StateError {}
private class StateErrorRobotNotUpToDate: GKState, StateError {}

// MARK: - StateMachine

class UpdateProcessV100: UpdateProcessProtocol {

    // MARK: - Private variables

    private var stateMachine: GKStateMachine?

    private var cancellables: Set<AnyCancellable> = []

    private var firmware = FirmwareManager()

    // MARK: - Public variables

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)

    init(robot: RobotPeripheralViewModel) {
        self.stateMachine = GKStateMachine(states: [
            StateInitial(),

            StateLoadingUpdateFile(firmware: firmware),
            StateSettingDestinationPath(firmware: firmware, robot: robot),
            StateSendingFile(firmware: firmware, robot: robot),
            StateApplyingUpdate(firmware: firmware, robot: robot),
            StateWaitingForRobotToReboot(robot: robot),

            StateFinal(),

            StateErrorFailedToLoadFile(),
            StateErrorRobotNotUpToDate(),
        ])
        self.stateMachine?.enter(StateInitial.self)
    }

    public func startProcess() {
        process(event: .startUpdateRequested)
    }

    private func process(event: UpdateEvent) {
        guard let state = stateMachine?.currentState as? any StateEventProcessor else {
            return
        }

        state.process(event: event)

        updateCurrentState()
    }

    private func updateCurrentState() {
        guard let state = stateMachine?.currentState else { return }

        switch state {
            case is StateInitial:
                currentStage.send(.initial)
            case is StateLoadingUpdateFile, is StateSettingDestinationPath, is StateSendingFile:
                currentStage.send(.sendingUpdate)
            case is StateApplyingUpdate, is StateWaitingForRobotToReboot:
                currentStage.send(.installingUpdate)
            case is StateFinal:
                currentStage.send(completion: .finished)
            case is any StateError:
                sendError(state: state)
            default:
                currentStage.send(completion: .failure(.unknown))
        }
    }

    private func sendError(state: GKState) {
        switch state {
            case is StateErrorFailedToLoadFile:
                currentStage.send(completion: .failure(.failedToLoadFile))
            case is StateErrorRobotNotUpToDate:
                currentStage.send(completion: .failure(.robotNotUpToDate))
            default:
                currentStage.send(completion: .failure(.unknown))
        }
    }

}
