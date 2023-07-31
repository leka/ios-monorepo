// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - General (user facing) update process states, errors

enum UpdateProcessStage {
    case initial

    // LekaOS 1.0.0+
    case sendingUpdate
    case installingUpdate
}

enum UpdateProcessError: Error {
    case unknown
    case updateProcessNotAvailable

    // LekaOS 1.0.0+
    case failedToLoadFile
    case robotNotUpToDate
}

// MARK: - Controller

class UpdateProcessController {

    // MARK: - Private variables

    private var currentUpdateProcess: any UpdateProcessProtocol

    // MARK: - Public variables

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)

    init(robotManager: RobotManager) {
        let currentRobotVersion = robotManager.osVersion

        switch currentRobotVersion {
            case "1.0.0", "1.1.0":
                self.currentUpdateProcess = UpdateProcessV100(robot: robotManager.robotPeripheral)
            default:
                self.currentUpdateProcess = UpdateProcessTemplate()
        }

        self.currentStage = self.currentUpdateProcess.currentStage
    }

    func startUpdate() {
        currentUpdateProcess.startProcess()
    }
}
