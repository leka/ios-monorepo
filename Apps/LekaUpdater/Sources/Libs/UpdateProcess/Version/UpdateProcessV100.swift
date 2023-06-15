// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import GameplayKit

private protocol StateEventProcessor {
    func process(event: UpdateProcessEvent)
}

private protocol ErrorState {}

//
// MARK: - States
//

private class InitialState: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LoadingUpdateFileState.Type
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .startUpdateRequested:
                self.stateMachine?.enter(LoadingUpdateFileState.self)
            default:
                return
        }
    }
}

private class LoadingUpdateFileState: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ErrorFailedToLoadFile.Type || stateClass is SettingDestinationPathState.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.loadUpdateFile()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .fileLoaded:
                self.stateMachine?.enter(SettingDestinationPathState.self)
            case .failedToLoadFile:
                self.stateMachine?.enter(ErrorFailedToLoadFile.self)
            default:
                return
        }
    }
}

private class SettingDestinationPathState: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SendingFileState.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.setBLEDestinationPathAndClearFile()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .destinationPathSet:
                self.stateMachine?.enter(SendingFileState.self)
            default:
                return
        }
    }
}

private class SendingFileState: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ApplyingUpdate.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.sendFile()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .fileSent:
                self.stateMachine?.enter(ApplyingUpdate.self)
            default:
                return
        }
    }
}

private class ApplyingUpdate: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.setBLEMajorMinorRevisionApply()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .robotDisconnected:
                self.stateMachine?.enter(WaitingRobotToReboot.self)
            default:
                return
        }
    }
}

private class WaitingRobotToReboot: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is FinalState.Type || stateClass is ErrorRobotNotUpToDate.Type
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .robotDetected:
                if controller.isRobotUpToDate() {
                    self.stateMachine?.enter(FinalState.self)
                } else {
                    self.stateMachine?.enter(ErrorRobotNotUpToDate.self)
                }
            default:
                return
        }
    }
}

private class FinalState: GKState {}

private class ErrorFailedToLoadFile: GKState, ErrorState {}
private class ErrorRobotNotUpToDate: GKState, ErrorState {}

//
// MARK: Controller
//

private class Controller {
    let robot: DummyRobotModel

    init(robot: DummyRobotModel) {
        self.robot = robot
    }

    fileprivate func loadUpdateFile() {
        print("Loading update file...")
        // TODO: Implement loadUpdateFile
    }

    fileprivate func setBLEDestinationPathAndClearFile() {
        print("Setting BLE Destination Path and Clear File...")
        // TODO: Implement setBLEDestinationPathAndClearFile
    }

    fileprivate func sendFile() {
        print("Sending file...")
        // TODO: Implement sendFile
    }

    fileprivate func setBLEMajorMinorRevisionApply() {
        print("Setting BLE Major Minor Revision Apply...")
        // TODO: Implement setBLEMajorMinorRevisionApply
    }

    fileprivate func isRobotUpToDate() -> Bool {
        // TODO: Implement isRobotUpToDate
        return false
    }
}
