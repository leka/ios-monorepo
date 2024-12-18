// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class DnDGridThreeChoicesScene: DnDGridBaseScene {
    override func setFirstAnswerPosition() {
        self.horizontalSpacer = size.width / 2
        self.verticalSpacer = size.height / 3
        self.initialNodeX = (size.width - self.horizontalSpacer) / 2
    }

    override func setInitialPosition(_ index: Int) -> CGPoint {
        if index / 2 < 1 {
            let positionX = self.initialNodeX + (self.horizontalSpacer * CGFloat(index % 2))
            let positionY = 2 * self.verticalSpacer + 30
            return CGPoint(x: positionX, y: positionY)
        } else {
            let positionX = size.width / 2
            let positionY = self.verticalSpacer - 30
            return CGPoint(x: positionX, y: positionY)
        }
    }
}
