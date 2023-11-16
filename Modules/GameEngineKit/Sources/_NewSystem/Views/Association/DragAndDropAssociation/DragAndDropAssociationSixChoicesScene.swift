// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

final class DragAndDropAssociationSixChoicesScene: DragAndDropAssociationBaseScene {

    override func setFirstAnswerPosition() {
        spacer = 340
        initialNodeX = (size.width - (spacer * 2)) / 2
        verticalSpacing = self.size.height / 3
        defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing - 30)
    }

    override func setNextAnswerPosition(_ index: Int) {
        if [0, 1, 3, 4].contains(index) {
            defaultPosition.x += spacer
        } else {
            defaultPosition.x = initialNodeX
            defaultPosition.y += verticalSpacing + 60
        }
    }

}
