// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

enum ExerciseState: Equatable {
    case idle
    case playing
    case completed(level: CompletionLevel)

    // MARK: Internal

    enum CompletionLevel {
        case fail
        case belowAverage
        case average
        case good
        case excellent
        case nonApplicable
    }
}
