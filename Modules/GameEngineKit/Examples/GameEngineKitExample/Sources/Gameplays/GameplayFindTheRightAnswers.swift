// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - FindTheRightAnswersChoiceState

enum FindTheRightAnswersChoiceState {
    case idle
    case selected
    case correct
    case wrong
}

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
    var state: FindTheRightAnswersChoiceState = .idle
}

// MARK: - GameplayFindTheRightAnswers

class GameplayFindTheRightAnswers: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [FindTheRightAnswersChoice]) {
        self.rawChoices = choices
        self.choices.value = choices
    }

    // MARK: Public

    public private(set) var choices = CurrentValueSubject<[FindTheRightAnswersChoice], Never>([])

    // MARK: Internal

    typealias ChoiceType = FindTheRightAnswersChoice

    func process(choice: FindTheRightAnswersChoice) {
        guard var currentChoice = choices.value.first(where: { $0.id == choice.id }) else { return }

        log.debug("[GP] \(currentChoice.id) - \(currentChoice.value.replacingOccurrences(of: "\n", with: " "))")

        if currentChoice.isRightAnswer {
            currentChoice.state = .correct
        } else {
            currentChoice.state = .wrong
        }

        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else { return }

        self.choices.value[index] = currentChoice
    }

    // MARK: Private

    private let rawChoices: [FindTheRightAnswersChoice]
}
