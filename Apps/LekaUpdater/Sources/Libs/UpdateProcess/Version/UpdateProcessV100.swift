// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateErrorFailedToLoadFile.Type || stateClass is StateSettingDestinationPath.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: load update file
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateSendingFile.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: set BLE destination path and clear file
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateApplyingUpdate.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: send file
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateWaitingForRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        // TODO: set BLE major, minor and revision apply
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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateFinal.Type || stateClass is StateErrorRobotNotUpToDate.Type
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

