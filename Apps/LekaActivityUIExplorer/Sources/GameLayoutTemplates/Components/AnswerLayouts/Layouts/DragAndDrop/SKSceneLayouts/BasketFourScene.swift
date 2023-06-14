// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class BasketFourScene: DragAndDropScene {

    let padding: CGFloat = 185

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = (size.width - (padding * 2)) / 3
        self.defaultPosition = CGPoint(x: padding, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }
}
