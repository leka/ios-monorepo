// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - GameplayTouchToSelectChoiceModel

struct GameplayTouchToSelectChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = TouchToSelect.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

extension GameplayFindTheRightAnswers where ChoiceModelType == GameplayTouchToSelectChoiceModel {
    convenience init(choices: [GameplayTouchToSelectChoiceModel], shuffle: Bool = false) {
        self.init()
        self.choices.send(shuffle ? choices.shuffled() : choices)
        rightAnswers = choices.filter(\.choice.isRightAnswer)
        state.send(.playing)
    }

    func process(_ choice: ChoiceModelType) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        if choice.choice.isRightAnswer, rightAnswers.isNotEmpty {
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
