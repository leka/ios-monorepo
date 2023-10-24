// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension GameplaySelectAllRightAnswers where ChoiceModelType == GameplayDragAndDropChoiceModel {

    convenience init(choices: [GameplayDragAndDropChoiceModel]) {
        self.init()
        self.choices.send(choices)
    }

    func process(_ choice: ChoiceModelType) {
        if choice.choice.dropZone == .zoneA {
            // do something
            log.info("Right answer")
        } else {
            // do something
            log.info("Wrong answer")
        }
    }

}
