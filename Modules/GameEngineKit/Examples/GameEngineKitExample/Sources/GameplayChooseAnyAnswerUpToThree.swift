// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - GameplayChooseAnyAnswerUpToThree

class GameplayChooseAnyAnswerUpToThree: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [FindTheRightAnswersChoice]) {
        self.rawChoices = choices
        self.choices.value = choices
    }

    // MARK: Public

    public private(set) var choices = CurrentValueSubject<[FindTheRightAnswersChoice], Never>([])

    // MARK: Internal

    typealias ChoiceType = FindTheRightAnswersChoice

    var exerciseHasBeenTerminated: Bool = false

    func process(choice: FindTheRightAnswersChoice) {
        guard var currentChoice = choices.value.first(where: { $0.id == choice.id }) else { return }

        log.debug("[GP] \(currentChoice.id) - \(currentChoice.value.replacingOccurrences(of: "\n", with: " "))")

        if self.answerCount < self.maxAnswers {
            currentChoice.state = .selected
            self.answerCount += 1
        } else {
            log.debug("The maximum number of answers has been reached.")
            return
        }

        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else { return }

        self.choices.value[index] = currentChoice

        if self.answerCount == self.maxAnswers {
            log.debug("The exercise is completed with \(self.maxAnswers) selected answers.")
        }
    }

    func terminateExercise() {
        self.maxAnswers = self.answerCount
        log.debug("The exercise is completed with \(self.maxAnswers) selected answers.")
    }

    // MARK: Private

    private var answerCount = 0
    private var maxAnswers = 3
    private let rawChoices: [FindTheRightAnswersChoice]
}
