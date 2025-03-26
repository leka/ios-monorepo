// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayFindTheRightOrderChoiceModelDragAndDropInOrder

// swiftlint:disable:next type_name
struct GameplayFindTheRightOrderChoiceModelDragAndDropInOrder: GameplayChoiceModelProtocol {
    typealias ChoiceType = DragAndDropInOrder.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var dropZoneIndex: Int?
    var state: GameplayChoiceState = .idle
}

// MARK: Equatable

extension GameplayFindTheRightOrderChoiceModelDragAndDropInOrder: Equatable {
    static func == (lhs: GameplayFindTheRightOrderChoiceModelDragAndDropInOrder, rhs: GameplayFindTheRightOrderChoiceModelDragAndDropInOrder) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayFindTheRightOrder where ChoiceModelType == GameplayFindTheRightOrderChoiceModelDragAndDropInOrder {
    convenience init(choices: [GameplayFindTheRightOrderChoiceModelDragAndDropInOrder], allowedTrials: Int? = nil) {
        self.init()
        self.rightAnswers = choices
        self.choices.send(choices)
        self.state.send(.playing())

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTRightOrder)
        }
    }

    func process(choice: ChoiceModelType) {
        guard answers.count < rightAnswers.count else {
            return
        }

        guard let dropZoneIndex = choice.dropZoneIndex else {
            return
        }

        self.handleChoiceDrop(choice: choice, dropZoneIndex: dropZoneIndex)

        if answers.count == rightAnswers.count {
            self.isWellSequenced = true
            self.numberOfTrials += 1

            for (index, answer) in rightAnswers.enumerated() {
                if self.answers[index]?.id == answer.id {
                    self.updateChoice(self.choices.value[index], state: .rightAnswer)
                } else {
                    self.updateChoice(self.choices.value[index], state: .idle)
                    self.isWellSequenced = false
                    answers[index] = nil
                }
            }
            if self.isWellSequenced {
                let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
                state.send(.completed(level: level))
            }
        }
    }

    func cancelChoice(_ choice: ChoiceModelType) {
        if let index = answers.first(where: { $0.value == choice }) {
            answers[index.key] = nil
        }
        updateChoice(choice, state: .idle)
    }

    private func handleChoiceDrop(choice: ChoiceModelType, dropZoneIndex: Int) {
        if let index = answers.first(where: { $0.value == choice }) {
            self.handleSelectedChoice(choice: choice, index: index.key, dropZoneIndex: dropZoneIndex)
        } else {
            self.handleIdleChoice(choice: choice, dropZoneIndex: dropZoneIndex)
        }
    }

    private func isMovable(choice: ChoiceModelType) -> Bool {
        self.choices.value.first(where: { choice.id == $0.id })!.state != .rightAnswer
    }

    private func handleSelectedChoice(choice: ChoiceModelType, index: Int, dropZoneIndex: Int) {
        if answers[dropZoneIndex] == choice {
            updateChoice(choice, state: .selected)
        } else if let previousChoice = answers[dropZoneIndex], isMovable(choice: previousChoice) {
            answers[index] = nil
            answers[dropZoneIndex] = choice
            updateChoice(previousChoice, state: .idle)
            updateChoice(choice, state: .selected)
        } else {
            answers[index] = nil
            answers[dropZoneIndex] = choice
            updateChoice(choice, state: .selected)
        }
    }

    private func handleIdleChoice(choice: ChoiceModelType, dropZoneIndex: Int) {
        if answers[dropZoneIndex] == nil {
            answers[dropZoneIndex] = choice
            updateChoice(choice, state: .selected)
        } else if let previousChoice = answers[dropZoneIndex], isMovable(choice: previousChoice) {
            answers[dropZoneIndex] = choice
            updateChoice(previousChoice, state: .idle)
            updateChoice(choice, state: .selected)
        } else {
            updateChoice(choice, state: .idle)
        }
    }
}
