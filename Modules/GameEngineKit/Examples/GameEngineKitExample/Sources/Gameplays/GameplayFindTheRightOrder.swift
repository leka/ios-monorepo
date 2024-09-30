// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - FindTheRightOrderChoice

struct FindTheRightOrderChoice: Identifiable, Equatable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String) {
        self.id = id
        self.value = value
    }

    // MARK: Internal

    let id: String
    let value: String

    static func == (lhs: FindTheRightOrderChoice, rhs: FindTheRightOrderChoice) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - GameplayFindTheRightOrder

class GameplayFindTheRightOrder: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [FindTheRightOrderChoice]) {
        self.orderedChoices = choices
    }

    // MARK: Public

    public private(set) var orderedChoices: [FindTheRightOrderChoice]

    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    // MARK: Internal

    typealias ChoiceType = FindTheRightOrderChoice

    func process(choices: [FindTheRightOrderChoice]) -> [(choice: FindTheRightOrderChoice, correctPosition: Bool)] {
        if self.orderedChoices == choices {
            self.isCompleted.send(true)
            return self.orderedChoices.map { (choice: $0, correctPosition: true) }
        }

        return self.orderedChoices.enumerated().map { index, choice in
            if self.orderedChoices[index] == choice {
                (choice: choice, correctPosition: true)
            } else {
                (choice: choice, correctPosition: false)
            }
        }
    }
}

extension GameplayFindTheRightOrder {
    public static let kDefaultChoices: [FindTheRightOrderChoice] = [
        FindTheRightOrderChoice(value: "1st choice"),
        FindTheRightOrderChoice(value: "2nd choice"),
        FindTheRightOrderChoice(value: "3rd choice"),
        FindTheRightOrderChoice(value: "4th choice"),
        FindTheRightOrderChoice(value: "5th choice"),
        FindTheRightOrderChoice(value: "6th choice"),
    ]
}
