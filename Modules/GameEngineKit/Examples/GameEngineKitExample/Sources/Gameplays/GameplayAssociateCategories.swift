// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - AssociateCategoriesChoice

struct AssociateCategoriesChoice: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, category: Category?) {
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
    let category: Category?
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

    public private(set) var choices = CurrentValueSubject<[AssociateCategoriesChoice], Never>([])

    // MARK: Internal

    typealias ChoiceType = AssociateCategoriesChoice

    func process(choice: AssociateCategoriesChoice) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else { return }
        self.choices.value[index] = choice
    }

    func checkForExerciseCompletion() {
        let categoryGroups = Dictionary(grouping: self.choices.value.filter { $0.category != nil }, by: { $0.category })

        for (_, choices) in categoryGroups {
            if choices.count > 1, !choices.allSatisfy({ $0.state == .correct }) {
                return
            }
        }

        self.endExercise()
    }

    func resetGame() {
        self.choices.value = self.choices.value.map { choice in
            var updatedChoice = choice
            updatedChoice.state = .idle
            return updatedChoice
        }
        log.debug("Incorrect choice. Restarting the game.")
    }

    func endExercise() {
        log.debug("Exercise successfully completed!")
    }
}
