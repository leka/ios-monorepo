// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DraggableImageShadowNode: SKSpriteNode {
    init(draggableImageAnswerNode: DraggableImageAnswerNode) {
        super
            .init(
                texture: draggableImageAnswerNode.texture, color: draggableImageAnswerNode.color,
                size: draggableImageAnswerNode.size)

        let actionShadow = SKAction.setTexture(draggableImageAnswerNode.texture!, resize: true)
        self.run(actionShadow)

        self.blendMode = SKBlendMode.alpha
        self.colorBlendFactor = 1.0
        self.color = .black
        self.alpha = 0.15
        self.setScale(draggableImageAnswerNode.xScale)
        self.position = draggableImageAnswerNode.position
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
