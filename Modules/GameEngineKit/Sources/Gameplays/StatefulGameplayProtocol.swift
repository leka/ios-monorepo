// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// MARK: - StatefulGameplayProtocol

protocol StatefulGameplayProtocol {
    associatedtype GameplayChoiceModelType

    var state: CurrentValueSubject<ExerciseState, Never> { get }

    func evaluateCompletionLevel(allowedTrials: Int, numberOfTrials: Int) -> ExerciseState.CompletionLevel
    func getNumberOfAllowedTrials(from table: GradingLUT) -> Int
}

extension StatefulGameplayProtocol {
    func evaluateCompletionLevel(allowedTrials: Int, numberOfTrials: Int) -> ExerciseState.CompletionLevel {
        let trialsPercentage = Double(allowedTrials) / Double(numberOfTrials) * 100.0
        switch trialsPercentage {
            case 90...:
                return .excellent
            case 80..<90:
                return .good
            case 70..<80:
                return .average
            case 60..<70:
                return .belowAverage
            default:
                return .fail
        }
    }
}
