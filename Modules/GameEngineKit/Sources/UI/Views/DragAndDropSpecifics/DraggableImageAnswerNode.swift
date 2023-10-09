// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DraggableImageAnswerNode: SKSpriteNode {

    var isDraggable: Bool = true
    var defaultPosition: CGPoint?

    init(choice: ChoiceModel, scale: CGFloat = 1, position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: choice.item), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.item
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
