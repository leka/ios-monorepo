// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class DnDGridSixChoicesScene: DnDGridBaseScene {
    override func setFirstAnswerPosition() {
        self.horizontalSpacer = size.width / 3
        self.verticalSpacer = size.height / 3
        self.initialNodeX = (size.width / 2) - self.horizontalSpacer
    }

    override func setInitialPosition(_ index: Int) -> CGPoint {
        let positionX = self.initialNodeX + (self.horizontalSpacer * CGFloat(index % 3))
        if index / 3 < 1 {
            let positionY = 2 * self.verticalSpacer + 30
            return CGPoint(x: positionX, y: positionY)
        } else {
            let positionY = self.verticalSpacer - 30
            return CGPoint(x: positionX, y: positionY)
        }
    }
}
