// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - GameplayTouchToSelectInRightOrderChoiceModel

struct GameplayTouchToSelectInRightOrderChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = TouchToSelectInRightOrder.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

extension GameplayFindTheRightAnswersInRightOrder where ChoiceModelType == GameplayTouchToSelectInRightOrderChoiceModel {
    convenience init(choices: [GameplayTouchToSelectInRightOrderChoiceModel], shuffle: Bool = false, allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(shuffle ? choices.shuffled() : choices)
        rightAnswersOrdered = choices.filter {
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
        guard rightAnswersOrdered.isNotEmpty else {
            return
        }

        numberOfTrials += 1

        if choice.id == rightAnswersOrdered.first?.id {
            updateChoice(choice, state: .rightAnswer)
            rightAnswersOrdered.removeFirst()
        } else if rightAnswersOrdered.contains(where: { $0.id == choice.id }) {
            updateChoice(choice, state: .idle)
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswersOrdered.isEmpty {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            state.send(.completed(level: level))
        }
    }
}
