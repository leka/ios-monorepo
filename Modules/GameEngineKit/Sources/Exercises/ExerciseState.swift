// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Foundation

// MARK: - ExerciseState

enum ExerciseState: Equatable {
    case idle
    case playing
    case completed(level: CompletionLevel, data: ExerciseCompletionData?)

    // MARK: Internal

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
