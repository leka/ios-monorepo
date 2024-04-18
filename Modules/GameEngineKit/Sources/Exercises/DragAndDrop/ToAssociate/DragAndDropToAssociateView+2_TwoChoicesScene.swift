// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

extension DragAndDropToAssociateView {
    final class TwoChoicesScene: BaseScene {
        override func setFirstAnswerPosition() {
            spacer = size.width / CGFloat(viewModel.choices.count + 1)
            defaultPosition = CGPoint(x: spacer, y: size.height / 2)
        }

        override func setNextAnswerPosition(_: Int) {
            defaultPosition.x += spacer
        }
    }
}
