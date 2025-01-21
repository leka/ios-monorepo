// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - NewGameplayFindTheRightOrderChoice

public struct NewGameplayFindTheRightOrderChoice: Identifiable, Equatable {
    // MARK: Lifecycle

    public init(id: String) {
        self.id = id
    }

    // MARK: Public

    public let id: String

    public static func == (lhs: NewGameplayFindTheRightOrderChoice, rhs: NewGameplayFindTheRightOrderChoice) -> Bool {
        lhs.id == rhs.id
    }
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

    func process(choiceIDs: [String]) -> [(id: String, correctPosition: Bool)] {
        if self.orderedChoices.map(\.id) == choiceIDs {
            self.isCompleted.send(true)
            return self.orderedChoices.map { (id: $0.id, correctPosition: true) }
        }

        return self.orderedChoices.enumerated().map { index, choice in
            if choiceIDs[index] == choice.id {
                (id: choice.id, correctPosition: true)
            } else {
                (id: choice.id, correctPosition: false)
            }
        }
    }
}
