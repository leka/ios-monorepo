// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension GameplaySelectAllRightAnswers where ChoiceModelType == GameplaySelectionChoiceModel {

    convenience init(choices: [GameplaySelectionChoiceModel]) {
        self.init()
        self.choices.send(choices)
    }

    func process(_ choice: ChoiceModelType) {
        if choice.choice.isRightAnswer {
            updateChoice(choice, state: .rightAnswer)
            state.send(.completed)
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }
    }

}
