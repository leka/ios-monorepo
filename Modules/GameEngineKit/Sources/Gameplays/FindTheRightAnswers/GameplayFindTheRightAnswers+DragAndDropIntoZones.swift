// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import Foundation

// MARK: - GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones

// swiftlint:disable:next type_name
struct GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones: GameplayChoiceModelProtocol {
    typealias ChoiceType = DragAndDropIntoZones.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType
    var droppedIntoZone: DragAndDropIntoZones.DropZone?
    var state: GameplayChoiceState = .idle
}

// MARK: Equatable

extension GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones: Equatable {
    static func == (lhs: GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones, rhs: GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayFindTheRightAnswers where ChoiceModelType == GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones {
    convenience init(choices: [GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones], allowedTrials: Int? = nil) {
        self.init()
        self.choices.send(choices)
        self.rightAnswers = choices.filter { $0.choice.dropZone != .none }
        self.state.send(.playing)

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTDefault)
        }
    }

    func process(choice: ChoiceModelType) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        numberOfTrials += 1

        if choice.choice.dropZone == choice.droppedIntoZone {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.removeAll { $0.id == choice.id }
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.isEmpty {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            state.send(.completed(level: level))
        }
    }
}
