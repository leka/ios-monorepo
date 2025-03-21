// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit

enum ExerciseState: Equatable {
    case idle
    case playing(type: PlayType = .structured)
    case completed(level: CompletionLevel)

    // MARK: Internal

    enum PlayType {
        case structured
        case unstructured
    }

    enum CompletionLevel {
        case fail
        case belowAverage
        case average
        case good
        case excellent
        case nonApplicable
    }

    var isCompleted: Bool {
        switch self {
            case .completed: true
            default: false
        }
    }
}
