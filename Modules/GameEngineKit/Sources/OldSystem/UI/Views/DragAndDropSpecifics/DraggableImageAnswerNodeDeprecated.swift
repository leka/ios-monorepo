// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DraggableImageAnswerNodeDeprecated: SKSpriteNode {

    var isDraggable: Bool = true
    var defaultPosition: CGPoint?

    init(choice: ChoiceModel, scale: CGFloat = 1, position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: choice.value), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.value
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
