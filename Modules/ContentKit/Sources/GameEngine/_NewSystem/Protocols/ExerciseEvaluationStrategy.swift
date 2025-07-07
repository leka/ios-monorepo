// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - EvaluationContext

public enum EvaluationContext {
    case discovery
    case practice
    case validation
}

// MARK: - ExerciseEvaluationLevel

public enum ExerciseEvaluationLevel {
    case fail
    case belowAverage
    case average
    case good
    case excellent
    case notApplicable
}

// MARK: - ExerciseEvaluationStrategy

public protocol ExerciseEvaluationStrategy {
    typealias EvaluationLUT = [Int: [Int: Int]]

    func evaluate(in context: EvaluationContext) -> ExerciseEvaluationLevel
}
