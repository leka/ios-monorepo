// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - States, errors

enum UpdateStatusState {
    case initial
}

enum UpdateStatusError: Error {
    case unknown
    case updateProcessNotAvailable
}

//
// MARK: - StateMachine
//

class UpdateProcessController {
    private var currentUpdateProcess: any UpdateProcessProtocol

    public var currentState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let currentRobotVersion = robot.osVersion

        switch currentRobotVersion {
            default:
                self.currentUpdateProcess = UpdateProcessUnavailable()
        }
        self.currentState = self.currentUpdateProcess.userState
    }

    func startUpdate() {
        currentUpdateProcess.startUpdate()
    }
}
