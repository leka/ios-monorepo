// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - General (user facing) update process states, errors

enum UpdateProcessStage {
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

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let currentRobotVersion = robot.osVersion

        switch currentRobotVersion {
            default:
                self.currentUpdateProcess = UpdateProcessTemplate()
        }

        self.currentStage = self.currentUpdateProcess.currentStage
    }

    func startUpdate() {
        currentUpdateProcess.startProcess()
    }
}
