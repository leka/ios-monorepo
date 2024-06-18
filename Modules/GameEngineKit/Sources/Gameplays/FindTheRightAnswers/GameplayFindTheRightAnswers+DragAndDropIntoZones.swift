// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayDragAndDropIntoZonesChoiceModel

struct GameplayDragAndDropIntoZonesChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = DragAndDropIntoZones.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

extension GameplayFindTheRightAnswers where ChoiceModelType == GameplayDragAndDropIntoZonesChoiceModel {
    convenience init(choices: [GameplayDragAndDropIntoZonesChoiceModel], allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(choices)
        self.rightAnswers = choices.filter { $0.choice.dropZone != .none }
        self.state.send(.playing) // (with arguments like completed?)
        self.startTimestamp = Date()

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(_ choice: ChoiceModelType, _ dropZone: DragAndDropIntoZones.DropZone) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        numberOfTrials += 1

        if choice.choice.dropZone == dropZone {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.removeAll { $0.id == choice.id }
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.isEmpty {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            let completionPayload = ExerciseCompletionData.StandardExercisePayload(
                numberOfTrials: self.numberOfTrials,
                numberOfAllowedTrials: self.allowedTrials
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
