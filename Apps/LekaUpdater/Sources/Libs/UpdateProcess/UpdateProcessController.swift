// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - States, errors

enum UpdateStatusState {
    case initial

    // LekaOS 1.0.0+
    case sendingUpdate
    case installingUpdate
}

enum UpdateStatusError: Error {
    case unknown
    case updateProcessNotAvailable

    // LekaOS 1.0.0+
    case failedToLoadFile
    case robotNotUpToDate
}

//
// MARK: - StateMachine
//

class UpdateProcessController {
    private var currentStateMachine: any UpdateProcessProtocol

    public var currentState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let currentRobotVersion = robot.osVersion

        switch currentRobotVersion {
            case "1.0.0", "1.1.0":
                self.currentStateMachine = UpdateProcessV100(robot: robot)
            default:
                self.currentStateMachine = UpdateProcessUnavailable()
        }
        self.currentState = self.currentStateMachine.userState
    }

    func startUpdate() {
        currentStateMachine.startUpdate()
    }
}
