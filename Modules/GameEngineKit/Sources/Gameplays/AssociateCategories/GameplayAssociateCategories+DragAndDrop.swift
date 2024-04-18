// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - GameplayAssociateCategoriesChoiceModel

struct GameplayAssociateCategoriesChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = DragAndDropToAssociate.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

extension GameplayAssociateCategories where ChoiceModelType == GameplayAssociateCategoriesChoiceModel {
    convenience init(choices: [GameplayAssociateCategoriesChoiceModel], shuffle _: Bool = false, allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(choices)
        state.send(.playing)

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(_ choice: ChoiceModelType, _ destination: ChoiceModelType) {
        numberOfTrials += 1

        if choice.choice.category == destination.choice.category {
            updateChoice(choice, state: .rightAnswer)
            updateChoice(destination, state: .rightAnswer)
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if choices.value.allSatisfy({ $0.state == .rightAnswer }) {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            state.send(.completed(level: level))
        }
    }
}
