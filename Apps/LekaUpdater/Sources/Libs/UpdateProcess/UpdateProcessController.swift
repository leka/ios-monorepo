// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit
import Version

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
    case robotUnexpectedDisconnection
}

// MARK: - Controller

class UpdateProcessController {

    // MARK: - Private variables

    private var currentUpdateProcess: any UpdateProcessProtocol

    // MARK: - Public variables

    public static let availableVersions = [
        Version(1, 0, 0),
        Version(1, 1, 0),
        Version(1, 2, 0),
        Version(1, 3, 0),
        Version(1, 4, 0),
    ]

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)
    public var sendingFileProgression = CurrentValueSubject<Float, Never>(0.0)

    init() {
        let currentRobotVersion = Version(Robot.shared.osVersion.value)

        switch currentRobotVersion {
            case Version(1, 0, 0), Version(1, 1, 0), Version(1, 2, 0):
                self.currentUpdateProcess = UpdateProcessV100()
            case Version(1, 3, 0), Version(1, 4, 0):
                self.currentUpdateProcess = UpdateProcessV130()
            default:
                self.currentUpdateProcess = UpdateProcessTemplate()
        }

        self.currentStage = self.currentUpdateProcess.currentStage
        self.sendingFileProgression = self.currentUpdateProcess.sendingFileProgression
    }

    func startUpdate() {
        currentUpdateProcess.startProcess()
    }
}
