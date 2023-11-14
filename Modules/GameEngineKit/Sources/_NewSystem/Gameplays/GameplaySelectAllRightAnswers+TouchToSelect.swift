// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension GameplaySelectAllRightAnswers where ChoiceModelType == GameplayTouchToSelectChoiceModel {

    convenience init(choices: [GameplayTouchToSelectChoiceModel], shuffle: Bool = false) {
        self.init()
        self.choices.send(shuffle ? choices.shuffled() : choices)
        self.rightAnswers = choices.filter { $0.choice.isRightAnswer }
        self.state.send(.playing)
    }

    func process(_ choice: ChoiceModelType) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        if choice.choice.isRightAnswer && rightAnswers.isNotEmpty {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.removeAll { $0.id == choice.id }
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.isEmpty {
            state.send(.completed)
        }
    }

}
