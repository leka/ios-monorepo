// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - General (user facing) update process states, errors

enum UpdateStatusState {
    case initial
}

enum UpdateStatusError: Error {
    case unknown
    case updateProcessNotAvailable
}

// MARK: - Controller

class UpdateProcessController {

    // MARK: - Private variables

    private var currentUpdateProcess: any UpdateProcessProtocol

    // MARK: - Public variables

    public var currentState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let currentRobotVersion = robot.osVersion

        switch currentRobotVersion {
            default:
                self.currentUpdateProcess = UpdateProcessTemplate()
        }

        self.currentState = self.currentUpdateProcess.currentState
    }

    func startUpdate() {
        currentUpdateProcess.startProcess()
    }
}
