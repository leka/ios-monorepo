// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - AssociateCategoriesChoice

struct AssociateCategoriesChoice: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, category: Category?, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.category = category
        self.type = type
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
    let type: ChoiceType
    let category: Category?
}

// MARK: - GameplayAssociateCategories

class GameplayAssociateCategories: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [AssociateCategoriesChoice]) {
        self.choices = choices
        let categoryGroups = Dictionary(grouping: choices.filter { $0.category != nil }, by: { $0.category })
        self.remainingRightAnswers = categoryGroups.values
            .filter { $0.count > 1 }
            .flatMap { $0 }
    }

    // MARK: Public

    public let choices: [AssociateCategoriesChoice]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choices: [[AssociateCategoriesChoice]]) -> [(choice: AssociateCategoriesChoice, correctCategory: Bool)] {
        var results = [(AssociateCategoriesChoice, Bool)]()

        for category in choices {
            let categoryGroups = Dictionary(grouping: category, by: { $0.category })
            for (_, categoryChoices) in categoryGroups {
                if categoryChoices.count > 1 {
                    categoryChoices.forEach { choice in
                        results.append((choice, true))
                        self.remainingRightAnswers.removeAll { $0.id == choice.id }
                    }
                } else if let choice = categoryChoices.first {
                    results.append((choice, false))
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

    typealias ChoiceType = AssociateCategoriesChoice

    // MARK: Private

    private var remainingRightAnswers: [AssociateCategoriesChoice]
}

extension GameplayAssociateCategories {
    // MARK: Public

    public static let kDefaultChoices: [AssociateCategoriesChoice] = [
        AssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        AssociateCategoriesChoice(value: "car.rear.fill", category: .categoryC, type: .sfsymbol),
        AssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        AssociateCategoriesChoice(value: "car.rear.fill", category: .categoryC, type: .sfsymbol),
        AssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        AssociateCategoriesChoice(value: "Maison", category: nil, type: .text),
    ]
}
