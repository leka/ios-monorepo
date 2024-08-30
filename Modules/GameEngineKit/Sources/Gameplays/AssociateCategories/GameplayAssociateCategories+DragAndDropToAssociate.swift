// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate

// swiftlint:disable:next type_name
class GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate: GameplayChoiceModelProtocol {
    // MARK: Lifecycle

    init(choice: ChoiceType, destination: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate? = nil, state: GameplayChoiceState = .idle) {
        self.choice = choice
        self.destination = destination
        self.state = state
    }

    // MARK: Internal

    typealias ChoiceType = DragAndDropToAssociate.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var destination: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate?
    var state: GameplayChoiceState = .idle
}

// MARK: Equatable

extension GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate: Equatable {
    static func == (lhs: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate, rhs: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayAssociateCategories where ChoiceModelType == GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate {
    convenience init(choices: [GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate], allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(choices)
        self.state.send(.playing())

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(_ choice: ChoiceModelType) {
        guard let destination = choice.destination else {
            return
        }

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
