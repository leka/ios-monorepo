// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DnDShadowNode: SKSpriteNode {
    init(node: DnDAnswerNode) {
        super.init(texture: node.texture, color: node.color, size: node.size)

        blendMode = SKBlendMode.alpha
        colorBlendFactor = 1.0
        color = .black
        alpha = 0.15
        setScale(node.xScale)
        position = node.position
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
