// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum GameplayType {
    case selectTheRightAnswer
    case selectAllRightAnswers
    case selectSomeRightAnswers
}

public func gameplaySelector(type: GameplayType, data: StandardGameplayData) -> any GameplayProtocol {
    switch type {
        case .selectTheRightAnswer:
            return GameplaySelectTheRightAnswer(choices: data.choices)
        case .selectAllRightAnswers:
            return GameplaySelectAllRightAnswers(choices: data.choices)
        case .selectSomeRightAnswers:
            return GameplaySelectSomeRightAnswers(
                choices: data.choices, rightAnswersToFind: data.answersNumber!)
    }
}
