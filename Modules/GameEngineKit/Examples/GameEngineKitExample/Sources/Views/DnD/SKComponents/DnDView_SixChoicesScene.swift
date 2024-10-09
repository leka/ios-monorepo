// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension DnDView {
    class SixChoicesScene: DnDBaseScene {
        override func setFirstAnswerPosition() {
            spacer = 2 * size.width / CGFloat(self.viewModel.choices.count)
            initialNodeX = (size.width / 2) - spacer
            verticalSpacing = 2 * size.height / CGFloat(self.viewModel.choices.count)
            defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing - 30)
        }

        override func setInitialPosition(_ index: Int) -> CGPoint {
            let positionX = initialNodeX + (spacer * CGFloat(index % 3))
            let positionY = verticalSpacing - 30 + (verticalSpacing + 60) * CGFloat(2 * index / self.viewModel.choices.count)
            return CGPoint(x: positionX, y: positionY)
        }
    }
}
