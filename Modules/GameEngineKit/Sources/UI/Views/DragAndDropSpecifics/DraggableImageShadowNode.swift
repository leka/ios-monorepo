// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DraggableImageShadowNode: SKSpriteNode {

    init(draggableItemNode: DraggableImageAnswerNode) {
        super.init(texture: draggableItemNode.texture, color: draggableItemNode.color, size: draggableItemNode.size)

        let actionShadow = SKAction.setTexture(draggableItemNode.texture!, resize: true)
        self.run(actionShadow)

        self.blendMode = SKBlendMode.alpha
        self.colorBlendFactor = 1.0
        self.color = .black
        self.alpha = 0.15
        self.setScale(draggableItemNode.xScale)
        self.position = draggableItemNode.position
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
