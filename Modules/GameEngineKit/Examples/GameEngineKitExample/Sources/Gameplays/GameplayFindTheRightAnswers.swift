// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - FindTheRightAnswersChoice

struct FindTheRightAnswersChoice: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, isRightAnswer: Bool) {
        self.id = id
        self.value = value
        self.isRightAnswer = isRightAnswer
    }

    // MARK: Internal

    let id: String
    let value: String
    let isRightAnswer: Bool
}

// MARK: - GameplayFindTheRightAnswers

class GameplayFindTheRightAnswers: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [FindTheRightAnswersChoice]) {
        self.choices = choices
    }

    // MARK: Public

    public let choices: [FindTheRightAnswersChoice]

    // MARK: Internal

    typealias ChoiceType = FindTheRightAnswersChoice

    func process(choices: [FindTheRightAnswersChoice]) -> [(choice: FindTheRightAnswersChoice, isCorrect: Bool)] {
        choices.map { choice in
            (choice, choice.isRightAnswer ? true : false)
        }
    }
}

extension GameplayFindTheRightAnswers {
    // MARK: Public

    public static let kDefaultChoices: [FindTheRightAnswersChoice] = [
        FindTheRightAnswersChoice(value: "Choice 1\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 2", isRightAnswer: false),
        FindTheRightAnswersChoice(value: "Choice 3\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 4", isRightAnswer: false),
        FindTheRightAnswersChoice(value: "Choice 5\nCorrect", isRightAnswer: true),
        FindTheRightAnswersChoice(value: "Choice 6", isRightAnswer: false),
    ]
}
