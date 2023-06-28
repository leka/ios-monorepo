// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class DropAreaOneAssetsThree: DropAreaOneAssetOne {

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = size.width / 4
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }
}
