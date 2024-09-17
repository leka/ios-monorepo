// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - AssociateCategoriesChoice

struct AssociateCategoriesChoice: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, category: Category) {
        self.id = id
        self.value = value
        self.category = category
    }

    // MARK: Internal

    enum Category {
        case categoryA
        case categoryB
        case categoryC
        case categoryD
    }

    let id: String
    let value: String
    let category: Category
    var state: AssociateCategoriesChoiceState = .idle
}

// MARK: - AssociateCategoriesChoiceState

enum AssociateCategoriesChoiceState {
    case idle
    case selected
    case correct
}

// MARK: - GameplayAssociateCategories

class GameplayAssociateCategories: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [AssociateCategoriesChoice]) {
        self.choices.value = choices
    }

    // MARK: Public

    // MARK: - Properties

    public private(set) var choices = CurrentValueSubject<[AssociateCategoriesChoice], Never>([])

    // MARK: Internal

    typealias ChoiceType = AssociateCategoriesChoice

    // MARK: - Methods

    func process(choice: AssociateCategoriesChoice) {
        guard let currentChoice = choices.value.first(where: { $0.id == choice.id }) else { return }

        if let firstChoice = firstSelectedChoice {
            if firstChoice.id != currentChoice.id, currentChoice.category == self.expectedCategory {
                log.debug("That's a correct match!")
                self.updateChoiceState(for: currentChoice, with: .correct)
                self.updateChoiceState(for: firstChoice, with: .correct)

                self.correctPairs += 1
                if self.correctPairs == self.totalPairs {
                    log.debug("Exercise completed.")
                }
            } else {
                log.debug("Incorrect match. Restarting the exercise.")
                self.restartExercise()
            }
            self.firstSelectedChoice = nil
        } else {
            self.firstSelectedChoice = currentChoice
            self.expectedCategory = currentChoice.category
            self.updateChoiceState(for: currentChoice, with: .selected)
        }
    }

    // MARK: Private

    private var selectedChoices: [AssociateCategoriesChoice] = []
    private var firstSelectedChoice: AssociateCategoriesChoice?
    private var expectedCategory: AssociateCategoriesChoice.Category?
    private var correctPairs = 0
    private let totalPairs = 3

    private func updateChoiceState(for choice: AssociateCategoriesChoice, with newState: AssociateCategoriesChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else { return }
        var updatedChoice = choice
        updatedChoice.state = newState
        self.choices.value[index] = updatedChoice
    }

    private func restartExercise() {
        self.choices.value = self.choices.value.map { choice in
            var updatedChoice = choice
            updatedChoice.state = .idle
            return updatedChoice
        }
        self.firstSelectedChoice = nil
        self.correctPairs = 0
    }
}
