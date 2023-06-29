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
            return GameplaySelectTheRightAnswer(choices: data.choices, rightAnswers: data.rightAnswers)
        case .selectAllRightAnswers:
            return GameplaySelectAllRightAnswers(choices: data.choices, rightAnswers: data.rightAnswers)
        case .selectSomeRightAnswers:
            return GameplaySelectSomeRightAnswers(
                choices: data.choices, rightAnswers: data.rightAnswers, rightAnswersToFind: data.answersNumber!)
    }
}
