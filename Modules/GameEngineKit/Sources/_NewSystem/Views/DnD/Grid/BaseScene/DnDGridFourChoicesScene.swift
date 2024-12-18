// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class DnDGridFourChoicesScene: DnDGridBaseScene {
    override func setPositionVariables() {
        self.horizontalSpacer = size.width / 2
        self.verticalSpacer = size.height / 3
        self.initialNodeX = (size.width - self.horizontalSpacer) / 2
    }

    override func setChoicePosition(_ index: Int) -> CGPoint {
        let positionX = self.initialNodeX + (self.horizontalSpacer * CGFloat(index % 2))
        if index / 2 < 1 {
            let positionY = 2 * self.verticalSpacer + 30
            return CGPoint(x: positionX, y: positionY)
        } else {
            let positionY = self.verticalSpacer - 30
            return CGPoint(x: positionX, y: positionY)
        }
    }
}