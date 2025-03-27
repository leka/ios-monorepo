// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropToAssociateView {
    final class FourChoicesScene: BaseScene {
        override func setFirstAnswerPosition() {
            spacer = size.width / 2
            initialNodeX = (size.width - spacer) / 2
            verticalSpacing = size.height / 3
            defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing - 30)
        }

        override func setNextAnswerPosition(_ index: Int) {
            if [0, 2].contains(index) {
                defaultPosition.x += spacer
            } else {
                defaultPosition.x = initialNodeX
                defaultPosition.y += verticalSpacing + 60
            }
        }
    }
}
