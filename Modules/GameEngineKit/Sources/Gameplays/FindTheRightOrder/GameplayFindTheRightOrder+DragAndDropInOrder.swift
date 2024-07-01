// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayDragAndDropInOrderChoiceModel

struct GameplayDragAndDropInOrderChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = DragAndDropInOrder.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

// MARK: Equatable

extension GameplayDragAndDropInOrderChoiceModel: Equatable {
    static func == (lhs: GameplayDragAndDropInOrderChoiceModel, rhs: GameplayDragAndDropInOrderChoiceModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayFindTheRightOrder where ChoiceModelType == GameplayDragAndDropInOrderChoiceModel {
    convenience init(choices: [GameplayDragAndDropInOrderChoiceModel], allowedTrials: Int? = nil) {
        self.init()
        self.rightAnswers = choices
        self.choices.send(choices)
        self.state.send(.playing)
        self.startTimestamp = Date()

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTRightOrder)
        }
    }

    func process(_ choice: ChoiceModelType, _ dropZoneIndex: Int) {
        guard answers.count < rightAnswers.count else {
            return
        }

        numberOfTrials += 1

        if answers[dropZoneIndex] == nil {
            answers[dropZoneIndex] = choice
            updateChoice(choice, state: .selected)
        }

        if answers.count == rightAnswers.count {
            self.isWellSequenced = true

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
                let completionPayload = ExerciseCompletionData.StandardExercisePayload(
                    numberOfTrials: self.allowedTrials,
                    numberOfAllowedTrials: self.numberOfTrials
                ).encodeToString()
                let completionData = ExerciseCompletionData(
                    startTimestamp: self.startTimestamp,
                    endTimestamp: Date(),
                    payload: completionPayload
                )
                state.send(.completed(level: level, data: completionData))
            }
        }
    }
}
