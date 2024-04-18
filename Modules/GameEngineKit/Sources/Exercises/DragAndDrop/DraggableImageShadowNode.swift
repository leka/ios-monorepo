// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DraggableImageShadowNode: SKSpriteNode {
    init(draggableImageAnswerNode: DraggableImageAnswerNode) {
        super
            .init(
                texture: draggableImageAnswerNode.texture, color: draggableImageAnswerNode.color,
                size: draggableImageAnswerNode.size
            )

        let actionShadow = SKAction.setTexture(draggableImageAnswerNode.texture!, resize: true)
        run(actionShadow)

        blendMode = SKBlendMode.alpha
        colorBlendFactor = 1.0
        color = .black
        alpha = 0.15
        setScale(draggableImageAnswerNode.xScale)
        position = draggableImageAnswerNode.position
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
