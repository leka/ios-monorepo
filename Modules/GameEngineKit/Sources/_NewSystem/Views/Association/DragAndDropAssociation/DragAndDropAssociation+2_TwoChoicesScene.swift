// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

final class DragAndDropAssociationTwoChoicesScene: DragAndDropAssociationBaseScene {

    override func setFirstAnswerPosition() {
        spacer = size.width / CGFloat(viewModel.choices.count + 1)
        defaultPosition = CGPoint(x: spacer, y: self.size.height / 2)
    }

    override func setNextAnswerPosition(_ index: Int) {
        self.defaultPosition.x += spacer
    }

}
