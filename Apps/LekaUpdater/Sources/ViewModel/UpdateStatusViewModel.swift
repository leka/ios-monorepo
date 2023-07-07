// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class UpdateStatusViewModel: ObservableObject {

    enum UpdateStatus {
        case sendingFile
        case rebootingRobot
        case updateFinished
    }

    @Published public var updatingStatus: UpdateStatus = .sendingFile

    public var stepNumber: Int {
        switch updatingStatus {
            case .sendingFile:
                return 1
            case .rebootingRobot:
                return 2
            case .updateFinished:
                return 3
        }
    }

}
