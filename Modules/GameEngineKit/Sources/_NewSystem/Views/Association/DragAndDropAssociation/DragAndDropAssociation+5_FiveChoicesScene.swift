// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

final class DragAndDropAssociationFiveChoicesScene: DragAndDropAssociationBaseScene {

    override func setFirstAnswerPosition() {
        spacer = 340
        initialNodeX = (size.width / 2) - spacer
        verticalSpacing = self.size.height / 3
        defaultPosition = CGPoint(x: initialNodeX, y: (verticalSpacing * 2) + 30)
    }

    override func setNextAnswerPosition(_ index: Int) {
        if index == 2 {
            defaultPosition.x = (size.width - spacer) / 2
            defaultPosition.y -= verticalSpacing + 60
        } else {
            defaultPosition.x += spacer
        }
    }

}
