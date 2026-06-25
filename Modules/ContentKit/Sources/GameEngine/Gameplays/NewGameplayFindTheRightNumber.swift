// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit

// MARK: - NewGameplayFindTheRightNumberChoiceModel

public struct NewGameplayFindTheRightNumberChoiceModel: Identifiable {
    // MARK: Lifecycle

    public init(id: UUID, isRightAnswer: Bool) {
        self.id = id
        self.isRightAnswer = isRightAnswer
    }

    // MARK: Public

    public let id: UUID

    // MARK: Internal

    let isRightAnswer: Bool
}

// MARK: - NewGameplayFindTheRightNumber

public class NewGameplayFindTheRightNumber: GameplayProtocol {
    // MARK: Lifecycle

    public init(choices: [NewGameplayFindTheRightNumberChoiceModel], requestedNumber: Int? = nil) {
        self.choices = choices
        self.rightAnswerIDs = Set(choices.filter(\.isRightAnswer).map(\.id))
        self.requestedNumber = requestedNumber ?? self.rightAnswerIDs.count
    }

    // MARK: Public

    public let choices: [NewGameplayFindTheRightNumberChoiceModel]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choiceIDs: [UUID]) -> [(id: UUID, isCorrect: Bool)] {
        let selectedChoiceIDs = Set(choiceIDs)
        let hasNoDuplicateSelection = selectedChoiceIDs.count == choiceIDs.count
        let hasRequestedNumberOfChoices = choiceIDs.count == self.requestedNumber
        let hasOnlyRightAnswers = selectedChoiceIDs.isSubset(of: self.rightAnswerIDs)
        let isSelectionCorrect = hasNoDuplicateSelection && hasRequestedNumberOfChoices && hasOnlyRightAnswers

        self.isCompleted.send(isSelectionCorrect)

        return choiceIDs.map { id in
            (id, self.rightAnswerIDs.contains(id))
        }
    }

    public func reset() {
        self.isCompleted.send(false)
    }

    // MARK: Internal

    typealias ChoiceType = NewGameplayFindTheRightNumberChoiceModel

    // MARK: Private

    private let requestedNumber: Int
    private let rightAnswerIDs: Set<UUID>
}
