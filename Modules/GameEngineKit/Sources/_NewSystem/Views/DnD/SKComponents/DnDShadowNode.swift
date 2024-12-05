// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DnDShadowNode: SKSpriteNode {
    init(node: DnDAnswerNode) {
        super.init(texture: nil, color: .clear, size: node.size)

        let shadowTexture = node.texture?.copy() as? SKTexture
        let shadowNode = SKSpriteNode(texture: shadowTexture)

        shadowNode.color = .black
        shadowNode.colorBlendFactor = 1.0
        shadowNode.alpha = 0.15
        shadowNode.blendMode = .alpha
        shadowNode.size = node.size
        shadowNode.position = node.position
        shadowNode.zPosition = -1

        self.addChild(shadowNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
