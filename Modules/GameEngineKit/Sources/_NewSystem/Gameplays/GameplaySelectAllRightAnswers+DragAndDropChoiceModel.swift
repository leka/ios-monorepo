// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

extension GameplaySelectAllRightAnswers where ChoiceModelType == GameplayDragAndDropChoiceModel {

    convenience init(choices: [GameplayDragAndDropChoiceModel]) {
        self.init()
        self.choices.send(choices)
        self.rightAnswers = choices.filter { $0.choice.dropZone != .none }
        self.state.send(.playing)
    }

    func process(_ choice: ChoiceModelType, _ dropZone: DragAndDropIntoZonesChoice.DropZone) {
        guard rightAnswers.isNotEmpty else {
            return
        }

        if choice.choice.dropZone == dropZone {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.removeAll { $0.id == choice.id }
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.isEmpty {
            state.send(.completed)
        }
    }

}
