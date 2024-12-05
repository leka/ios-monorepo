// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - NewGameplayFindTheRightOrderChoice

public struct NewGameplayFindTheRightOrderChoice: Identifiable, Equatable {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, type: ChoiceType = .text, alreadyOrdered: Bool = false) {
        self.id = id
        self.value = value
        self.type = type
        self.alreadyOrdered = alreadyOrdered
    }

    // MARK: Public

    public let id: String

    public static func == (lhs: NewGameplayFindTheRightOrderChoice, rhs: NewGameplayFindTheRightOrderChoice) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Internal

    static let zero = NewGameplayFindTheRightOrderChoice(value: "")

    let value: String
    let type: ChoiceType
    let alreadyOrdered: Bool
}

// MARK: - NewGameplayFindTheRightOrder

public class NewGameplayFindTheRightOrder: GameplayProtocol {
    // MARK: Lifecycle

    public init(choices: [NewGameplayFindTheRightOrderChoice]) {
        self.orderedChoices = choices
    }

    // MARK: Public

    public private(set) var orderedChoices: [NewGameplayFindTheRightOrderChoice]

    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    // MARK: Internal

    typealias ChoiceType = NewGameplayFindTheRightOrderChoice

    func process(choices: [NewGameplayFindTheRightOrderChoice]) -> [(choice: NewGameplayFindTheRightOrderChoice, correctPosition: Bool)] {
        if self.orderedChoices == choices {
            self.isCompleted.send(true)
            return self.orderedChoices.map { (choice: $0, correctPosition: true) }
        }

        return self.orderedChoices.enumerated().map { index, choice in
            if choices[index] == choice {
                (choice: choice, correctPosition: true)
            } else {
                (choice: choice, correctPosition: false)
            }
        }
    }
}

public extension NewGameplayFindTheRightOrder {
    static let kDefaultChoices: [NewGameplayFindTheRightOrderChoice] = [
        NewGameplayFindTheRightOrderChoice(value: "1st choice"),
        NewGameplayFindTheRightOrderChoice(value: "2nd choice"),
        NewGameplayFindTheRightOrderChoice(value: "3rd choice"),
        NewGameplayFindTheRightOrderChoice(value: "4th choice"),
        NewGameplayFindTheRightOrderChoice(value: "5th choice"),
        NewGameplayFindTheRightOrderChoice(value: "6th choice"),
    ]

    static let kDefaultImageChoicesWithZones: [NewGameplayFindTheRightOrderChoice] = [
        NewGameplayFindTheRightOrderChoice(value: "sequencing_dressing_up_1", type: .image, alreadyOrdered: true),
        NewGameplayFindTheRightOrderChoice(value: "sequencing_dressing_up_2", type: .image, alreadyOrdered: false),
        NewGameplayFindTheRightOrderChoice(value: "sequencing_dressing_up_3", type: .image, alreadyOrdered: false),
        NewGameplayFindTheRightOrderChoice(value: "sequencing_dressing_up_4", type: .image, alreadyOrdered: true),
        NewGameplayFindTheRightOrderChoice(value: "sequencing_dressing_up_5", type: .image, alreadyOrdered: false),
    ]
}
