// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropToAssociateView {
    final class SixChoicesScene: BaseScene {
        override func setFirstAnswerPosition() {
            spacer = 340
            initialNodeX = (size.width / 2) - spacer
            verticalSpacing = size.height / 3
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
}
