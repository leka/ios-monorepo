// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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
    // TODO: (@HPezz): Create gameplay related grading table search function & allowedTrials in args
    convenience init(choices: [GameplayDragAndDropIntoZonesChoiceModel]) {
        self.init()
        self.choices.send(choices)
        rightAnswers = choices.filter { $0.choice.dropZone != .none }
        state.send(.playing)

        let numberOfChoices = self.choices.value.count
        let numberOfRightAnswers = self.rightAnswers.count

        self.allowedTrials = kDefaultGradingTable[numberOfChoices]![numberOfRightAnswers]!
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
            state.send(.completed(level: level))
        }
    }
}
