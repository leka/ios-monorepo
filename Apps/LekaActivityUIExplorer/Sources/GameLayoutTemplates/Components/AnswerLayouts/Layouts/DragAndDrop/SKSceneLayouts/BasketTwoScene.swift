// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class BasketTwoScene: DragAndDropScene {

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = size.width / 3
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }
}
