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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ErrorFailedToLoadFile.Type || stateClass is SettingDestinationPathState.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: controller.loadUpdateFile()
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SendingFileState.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: controller.setBLEDestinationPathAndClearFile()
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ApplyingUpdate.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: controller.sendFile()
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: controller.setBLEMajorMinorRevisionApply()
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is FinalState.Type || stateClass is ErrorRobotNotUpToDate.Type
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .robotDetected:
                let isRobotUpToDate = true
                if isRobotUpToDate {
                // TODO: if controller.isRobotUpToDate() {
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
