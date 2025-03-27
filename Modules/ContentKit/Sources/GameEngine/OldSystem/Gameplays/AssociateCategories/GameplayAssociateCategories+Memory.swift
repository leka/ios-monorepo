// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Foundation

// MARK: - GameplayAssociateCategoriesChoiceModelMemory

// swiftlint:disable:next type_name
struct GameplayAssociateCategoriesChoiceModelMemory: GameplayChoiceModelProtocol {
    typealias ChoiceType = Memory.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

// MARK: Equatable

extension GameplayAssociateCategoriesChoiceModelMemory: Equatable {
    static func == (lhs: GameplayAssociateCategoriesChoiceModelMemory, rhs: GameplayAssociateCategoriesChoiceModelMemory) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayAssociateCategories where ChoiceModelType == GameplayAssociateCategoriesChoiceModelMemory {
    convenience init(choices: [GameplayAssociateCategoriesChoiceModelMemory], allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(choices)
        self.state.send(.playing())

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTMemory)
        }
    }

    func process(choice: ChoiceModelType) {
        let numberOfCardInCategories = self.choices.value.count / Set(choices.value.map(\.choice.category)).count
        updateChoice(choice, state: .selected)
        self.selectedChoices.append(choice)
        self.isTappable.send(false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.selectedChoices.count >= 2 {
                let firstChoice = self.selectedChoices[0]
                let lastChoice = self.selectedChoices.last!

                if firstChoice.choice.category != lastChoice.choice.category {
                    for choice in self.selectedChoices {
                        self.updateChoice(choice, state: .idle)
                    }

                    self.selectedChoices.removeAll()
                    self.isTappable.send(true)
                    return
                }

                if self.selectedChoices.count == numberOfCardInCategories, firstChoice.choice.category == lastChoice.choice.category {
                    for choice in self.selectedChoices {
                        self.updateChoice(choice, state: .rightAnswer)
                        self.rightAnswers.append(choice)
                    }

                    self.selectedChoices.removeAll()
                }
            }

            if self.rightAnswers.count == self.choices.value.count {
                let level = self.evaluateCompletionLevel(allowedTrials: self.allowedTrials, numberOfTrials: self.numberOfTrials)
                self.state.send(.completed(level: level))
            }

            self.isTappable.send(true)
        }
    }
}
