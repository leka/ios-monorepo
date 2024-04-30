// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - GameplayTouchToSelectInRightOrderChoiceModel

struct GameplayTouchToSelectInRightOrderChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = TouchToSelect.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

extension GameplayFindTheRightAnswers where ChoiceModelType == GameplayTouchToSelectInRightOrderChoiceModel {
    convenience init(choices: [GameplayTouchToSelectInRightOrderChoiceModel], shuffle: Bool = false, allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(shuffle ? choices.shuffled() : choices)
        rightAnswers = choices.filter {
            $0.choice.order != -1
        }.sorted {
            $0.choice.order < $1.choice.order
        }

        state.send(.playing)

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(_ choice: ChoiceModelType) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        numberOfTrials += 1

        if choice.id == rightAnswers.first?.id {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.removeFirst()
        } else if rightAnswers.contains(where: { $0.id == choice.id }) {
            updateChoice(choice, state: .idle)
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.isEmpty {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            state.send(.completed(level: level))
        }
    }
}
