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
    convenience init(choices: [GameplayAssociateCategoriesChoiceModel], shuffle _: Bool = false) {
        self.init()
        self.choices.send(choices)
        state.send(.playing)
    }

    func process(_ choice: ChoiceModelType, _ destination: ChoiceModelType) {
        if choice.choice.category == destination.choice.category {
            updateChoice(choice, state: .rightAnswer)
            updateChoice(destination, state: .rightAnswer)

        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if choices.value.allSatisfy({ $0.state == .rightAnswer }) {
            state.send(.completed)
        }
    }
}
