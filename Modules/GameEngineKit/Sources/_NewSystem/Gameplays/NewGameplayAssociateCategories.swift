// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - NewGameplayAssociateCategoriesChoice

public struct NewGameplayAssociateCategoriesChoice: Identifiable {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, category: Category?, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.category = category
        self.type = type
    }

    // MARK: Public

    public enum Category {
        case categoryA
        case categoryB
        case categoryC
        case categoryD
    }

    public let id: String

    // MARK: Internal

    let value: String
    let type: ChoiceType
    let category: Category?
}

// MARK: - NewGameplayAssociateCategories

public class NewGameplayAssociateCategories: GameplayProtocol {
    // MARK: Lifecycle

    public init(choices: [NewGameplayAssociateCategoriesChoice]) {
        self.choices = choices
        let categoryGroups = Dictionary(grouping: choices.filter { $0.category != nil }, by: { $0.category })
        self.remainingRightAnswers = categoryGroups.values
            .filter { $0.count > 1 }
            .flatMap { $0 }
    }

    // MARK: Public

    public let choices: [NewGameplayAssociateCategoriesChoice]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choices: [[NewGameplayAssociateCategoriesChoice]]) -> [(choice: NewGameplayAssociateCategoriesChoice, correctCategory: Bool)] {
        var results = [(NewGameplayAssociateCategoriesChoice, Bool)]()

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

    typealias ChoiceType = NewGameplayAssociateCategoriesChoice

    // MARK: Private

    private var remainingRightAnswers: [NewGameplayAssociateCategoriesChoice]
}

public extension NewGameplayAssociateCategories {
    // MARK: Public

    static let kDefaultChoices: [NewGameplayAssociateCategoriesChoice] = [
        NewGameplayAssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "Maison", category: nil, type: .text),
    ]

    static let kDefaultChoicesWithZones: [NewGameplayAssociateCategoriesChoice] = [
        NewGameplayAssociateCategoriesChoice(value: "sun", category: .categoryA, type: .text),
        NewGameplayAssociateCategoriesChoice(value: "car", category: .categoryB, type: .text),
        NewGameplayAssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        NewGameplayAssociateCategoriesChoice(value: "Maison", category: nil, type: .text),
    ]
}
