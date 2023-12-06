// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit

class DraggableImageAnswerNode: SKSpriteNode {

    var id: String
    var isDraggable: Bool = true
    var defaultPosition: CGPoint?

    init(choice: GameplayAssociateCategoriesChoiceModel, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        super.init(texture: SKTexture(image: UIImage(named: choice.choice.value)!), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.choice.value
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
    }

    init(choice: GameplayDragAndDropIntoZonesChoiceModel, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        super.init(texture: SKTexture(image: UIImage(named: choice.choice.value)!), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.choice.value
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
