// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
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
    private var robot: RobotPeripheral?

    init(firmware: FirmwareManager, robot: RobotPeripheral?) {
        self.firmware = firmware
        self.robot = robot
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateSendingFile.Type
    }

    override func didEnter(from previousState: GKState?) {
        setDestinationPath()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .destinationPathSet:
                self.stateMachine?.enter(StateSendingFile.self)
            default:
                return
        }
    }

    private func setDestinationPath() {
        let osVersion = firmware.currentVersion

        let directory = "/fs/usr/os"
        let filename = "LekaOS-\(osVersion).bin"
        let destinationPath = directory + "/" + filename

        var characteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.filePath,
            serviceUUID: BLESpecs.FileExchange.service
        )

        characteristic.onWrite = {
            self.process(event: .destinationPathSet)
        }

        robot?.send(destinationPath.data(using: .utf8)!, forCharacteristic: characteristic)
    }
}

private class StateSendingFile: GKState, StateEventProcessor {

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
    private var robot: RobotPeripheral?

    init(firmware: FirmwareManager, robot: RobotPeripheral?) {
        self.firmware = firmware
        self.robot = robot
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateWaitingForRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        setMajorMinorRevision()
        applyUpdate()

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

    private func setMajorMinorRevision() {
        let majorData = Data([firmware.major])

        let majorCharacteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMajor,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        robot?.send(majorData, forCharacteristic: majorCharacteristic)

        let minorData = Data([firmware.minor])

        let minorCharacteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMinor,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        robot?.send(minorData, forCharacteristic: minorCharacteristic)

        let revisionData = Data([UInt8(firmware.revision >> 8), UInt8(firmware.revision & 0x00FF)])

        let revisionCharacteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionRevision,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        robot?.send(revisionData, forCharacteristic: revisionCharacteristic)
    }

    private func applyUpdate() {
        let applyValue = Data([1])

        let characteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.requestUpdate,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        robot?.send(applyValue, forCharacteristic: characteristic)
    }
}

private class StateWaitingForRobotToReboot: GKState, StateEventProcessor {

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

    init(robot: RobotPeripheral?) {
        self.stateMachine = GKStateMachine(states: [
            StateInitial(),

            StateLoadingUpdateFile(firmware: firmware),
            StateSendingFile(),
            StateApplyingUpdate(firmware: firmware, robot: robot),
            StateWaitingForRobotToReboot(),
            StateSettingDestinationPath(firmware: firmware, robot: robot),

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
