// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropToAssociateView {
    final class FiveChoicesScene: BaseScene {
        override func setFirstAnswerPosition() {
            spacer = size.width / 3
            initialNodeX = (size.width / 2) - spacer
            verticalSpacing = size.height / 3
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
}
