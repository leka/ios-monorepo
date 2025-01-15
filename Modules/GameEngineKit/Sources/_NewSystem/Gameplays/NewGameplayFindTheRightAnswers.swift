// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit

// MARK: - NewGameplayFindTheRightAnswersChoiceModel

public struct NewGameplayFindTheRightAnswersChoiceModel: Identifiable {
    // MARK: Lifecycle

    public init(id: String, isRightAnswer: Bool) {
        self.id = id
        self.isRightAnswer = isRightAnswer
    }

    // MARK: Public

    public let id: String

    // MARK: Internal

    let isRightAnswer: Bool
}

// MARK: - NewGameplayFindTheRightAnswers

public class NewGameplayFindTheRightAnswers: GameplayProtocol {
    // MARK: Lifecycle

    public init(choices: [NewGameplayFindTheRightAnswersChoiceModel]) {
        self.choices = choices
        self.remainingRightAnswers = choices.filter(\.isRightAnswer)
    }

    // MARK: Public

    public let choices: [NewGameplayFindTheRightAnswersChoiceModel]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choiceIDs: [String]) -> [(id: String, isCorrect: Bool)] {
        let results: [(String, Bool)] = choiceIDs.compactMap { [weak self] id in
            guard let self else { return nil }

            let isRightAnswer: Bool = self.remainingRightAnswers.first(where: { id == $0.id })?.isRightAnswer ?? false

            self.remainingRightAnswers.removeAll(where: { $0.id == id })

            return (id, isRightAnswer)
        }

        if self.remainingRightAnswers.isEmpty {
            self.isCompleted.send(true)
            Robot.shared.run(.fire, onReinforcerCompleted: self.reset)
        }

        return results
    }

    public func reset() {
        self.remainingRightAnswers = self.choices.filter(\.isRightAnswer)
        self.isCompleted.send(false)
    }

    // MARK: Internal

    typealias ChoiceType = NewGameplayFindTheRightAnswersChoiceModel

    // MARK: Private

    private var remainingRightAnswers: [NewGameplayFindTheRightAnswersChoiceModel]
}
