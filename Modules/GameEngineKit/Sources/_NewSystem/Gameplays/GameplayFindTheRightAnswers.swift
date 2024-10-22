// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - FindTheRightAnswersChoice

struct FindTheRightAnswersChoice: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, isRightAnswer: Bool, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
        self.type = type
    }

    // MARK: Internal

    let id: String
    let value: String
    let type: ChoiceType
    let isRightAnswer: Bool
}

// MARK: - GameplayFindTheRightAnswers

class GameplayFindTheRightAnswers: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [FindTheRightAnswersChoice]) {
        self.choices = choices
        self.remainingRightAnswers = choices.filter(\.isRightAnswer)
    }

    // MARK: Public

    public let choices: [FindTheRightAnswersChoice]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choices: [FindTheRightAnswersChoice]) -> [(choice: FindTheRightAnswersChoice, isCorrect: Bool)] {
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

    typealias ChoiceType = FindTheRightAnswersChoice

    // MARK: Private

    private var remainingRightAnswers: [FindTheRightAnswersChoice]
}

extension GameplayFindTheRightAnswers {
    // MARK: Public

    public static let kDefaultChoices: [FindTheRightAnswersChoice] = [
        FindTheRightAnswersChoice(value: "Choice 1\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 2", isRightAnswer: false),
        FindTheRightAnswersChoice(value: "Choice 3\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        FindTheRightAnswersChoice(value: "Choice 5\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]
}
