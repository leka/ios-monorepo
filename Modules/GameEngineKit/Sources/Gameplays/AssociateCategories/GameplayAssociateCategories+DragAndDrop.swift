// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayAssociateCategoriesChoiceModel

struct GameplayAssociateCategoriesChoiceModel: GameplayChoiceModelProtocol {
    typealias ChoiceType = DragAndDropToAssociate.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var state: GameplayChoiceState = .idle
}

extension GameplayAssociateCategories where ChoiceModelType == GameplayAssociateCategoriesChoiceModel {
    convenience init(choices: [GameplayAssociateCategoriesChoiceModel], allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(choices)
        self.state.send(.playing)
        self.startTimestamp = Date()

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(_ choice: ChoiceModelType, _ destination: ChoiceModelType) {
        numberOfTrials += 1

        if choice.choice.category == destination.choice.category {
            updateChoice(choice, state: .rightAnswer)
            updateChoice(destination, state: .rightAnswer)
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if choices.value.allSatisfy({ $0.state == .rightAnswer }) {
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
