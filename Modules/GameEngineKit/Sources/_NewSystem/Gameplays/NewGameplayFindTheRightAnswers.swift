// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - NewGameplayFindTheRightAnswersChoice

public struct NewGameplayFindTheRightAnswersChoice: Identifiable {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, isRightAnswer: Bool, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
        self.type = type
    }

    // MARK: Public

    public let id: String

    // MARK: Internal

    let value: String
    let type: ChoiceType
    let isRightAnswer: Bool
}

// MARK: - NewGameplayFindTheRightAnswers

public class NewGameplayFindTheRightAnswers: GameplayProtocol {
    // MARK: Lifecycle

    public init(choices: [NewGameplayFindTheRightAnswersChoice]) {
        self.choices = choices
        self.remainingRightAnswers = choices.filter(\.isRightAnswer)
    }

    // MARK: Public

    public let choices: [NewGameplayFindTheRightAnswersChoice]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choices: [NewGameplayFindTheRightAnswersChoice]) -> [(choice: NewGameplayFindTheRightAnswersChoice, isCorrect: Bool)] {
        let results = choices.map { choice in
            self.remainingRightAnswers.removeAll { $0.id == choice.id }
            return (choice, choice.isRightAnswer ? true : false)
        }

        if self.remainingRightAnswers.isEmpty {
            self.isCompleted.send(true)
        }

        return results
    }

    public func reset() {
        self.remainingRightAnswers = self.choices.filter(\.isRightAnswer)
        self.isCompleted.send(false)
    }

    // MARK: Internal

    typealias ChoiceType = NewGameplayFindTheRightAnswersChoice

    // MARK: Private

    private var remainingRightAnswers: [NewGameplayFindTheRightAnswersChoice]
}

public extension NewGameplayFindTheRightAnswers {
    // MARK: Public

    static let kDefaultChoices: [NewGameplayFindTheRightAnswersChoice] = [
        NewGameplayFindTheRightAnswersChoice(value: "Choice 1\nCorrect", isRightAnswer: true),
        NewGameplayFindTheRightAnswersChoice(value: "Choice 2", isRightAnswer: false),
        NewGameplayFindTheRightAnswersChoice(value: "Choice 3\nCorrect", isRightAnswer: true),
        NewGameplayFindTheRightAnswersChoice(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        NewGameplayFindTheRightAnswersChoice(value: "Choice 5\nCorrect", isRightAnswer: true),
        NewGameplayFindTheRightAnswersChoice(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]
}
