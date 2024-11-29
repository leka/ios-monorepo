// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - NewGameplayFindTheRightOrderChoice

public struct NewGameplayFindTheRightOrderChoice: Identifiable, Equatable {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.type = type
    }

    // MARK: Public

    public let id: String

    public static func == (lhs: NewGameplayFindTheRightOrderChoice, rhs: NewGameplayFindTheRightOrderChoice) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Internal

    let value: String
    let type: ChoiceType
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
}
