// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class DnDGridTwoChoicesScene: DnDGridBaseScene {
    override func setPositionVariables() {
        self.horizontalSpacer = size.width / 2
        self.verticalSpacer = size.height / 2
        self.initialNodeX = (size.width - self.horizontalSpacer) / 2
    }

    override func setChoicePosition(_ index: Int) -> CGPoint {
        let positionX = self.initialNodeX + (self.horizontalSpacer * CGFloat(index % 2))
        return CGPoint(x: positionX, y: self.verticalSpacer)
    }
}
