// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayFindTheRightAnswersChoiceModelTouchToSelect

// swiftlint:disable:next type_name
struct GameplayFindTheRightAnswersChoiceModelTouchToSelect: GameplayChoiceModelProtocol {
    typealias ChoiceType = TouchToSelect.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

// MARK: Equatable

extension GameplayFindTheRightAnswersChoiceModelTouchToSelect: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayFindTheRightAnswers where ChoiceModelType == GameplayFindTheRightAnswersChoiceModelTouchToSelect {
    convenience init(choices: [GameplayFindTheRightAnswersChoiceModelTouchToSelect], shuffle: Bool = false, allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(shuffle ? choices.shuffled() : choices)
        self.rightAnswers = choices.filter(\.choice.isRightAnswer)
        self.state.send(.playing())

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(choice: ChoiceModelType) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        numberOfTrials += 1

        if choice.choice.isRightAnswer, rightAnswers.isNotEmpty {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.removeAll { $0.id == choice.id }
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.isEmpty {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            state.send(.completed(level: level))
        }
    }
}
