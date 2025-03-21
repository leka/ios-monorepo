// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - AssociateCategory

public enum AssociateCategory: String, Codable {
    case categoryA = "catA"
    case categoryB = "catB"
    case categoryC = "catC"
    case categoryD = "catD"
}

// MARK: - NewGameplayAssociateCategoriesChoiceModel

public struct NewGameplayAssociateCategoriesChoiceModel: Identifiable {
    // MARK: Lifecycle

    public init(id: UUID, category: AssociateCategory?) {
        self.id = id
        self.category = category
    }

    // MARK: Public

    public let id: UUID

    // MARK: Internal

    let category: AssociateCategory?
}

// MARK: - NewGameplayAssociateCategories

public class NewGameplayAssociateCategories: GameplayProtocol {
    // MARK: Lifecycle

    public init(choices: [NewGameplayAssociateCategoriesChoiceModel]) {
        self.choices = choices
        let categoryGroups = Dictionary(grouping: choices.filter { $0.category != nil }, by: { $0.category })
        self.remainingRightAnswers = categoryGroups.values
            .filter { $0.count > 1 }
            .flatMap { $0 }
    }

    // MARK: Public

    public let choices: [NewGameplayAssociateCategoriesChoiceModel]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choiceIDs: [[UUID]]) -> [(id: UUID, isCategoryCorrect: Bool)] {
        var results: [(id: UUID, isCategoryCorrect: Bool)] = []

        let selectedChoices: [[NewGameplayAssociateCategoriesChoiceModel]] = choiceIDs.map { idArray in
            idArray.compactMap { id in
                self.choices.first { $0.id == id }
            }
        }

        for category in selectedChoices {
            let correctCategory = category[0].category
            let categoryGroups = Dictionary(grouping: category, by: { $0.category })
            for (subCategory, categoryChoices) in categoryGroups {
                if categoryChoices.count > 1, subCategory == correctCategory {
                    categoryChoices.forEach { choice in
                        results.append((choice.id, true))
                        self.remainingRightAnswers.removeAll { $0.id == choice.id }
                    }
                } else if let choice = categoryChoices.first {
                    results.append((choice.id, false))
                }
            }
        }

        self.isCompleted.send(self.remainingRightAnswers.isEmpty)

        return results
    }

    public func reset() {
        let categoryGroups = Dictionary(grouping: choices, by: { $0.category })
        self.remainingRightAnswers = categoryGroups.values
            .filter { $0.count > 1 }
            .flatMap { $0 }
        self.isCompleted.send(false)
    }

    // MARK: Internal

    typealias ChoiceType = NewGameplayAssociateCategoriesChoiceModel

    // MARK: Private

    private var remainingRightAnswers: [NewGameplayAssociateCategoriesChoiceModel]
}
