// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit

class DraggableImageAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(choice: GameplayAssociateCategoriesChoiceModel, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        if let path = Bundle.path(forImage: choice.choice.value) {
            log.debug("Image found at path: \(path)")
            super.init(texture: SKTexture(image: UIImage(named: path)!), color: .clear, size: CGSize.zero)
        } else {
            log.error("Image not found: \(choice.choice.value)")
            super.init(texture: SKTexture(image: UIImage(named: choice.choice.value)!), color: .clear, size: CGSize.zero)
        }

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

        if let path = Bundle.path(forImage: choice.choice.value) {
            log.debug("Image found at path: \(path)")
            super.init(texture: SKTexture(image: UIImage(named: path)!), color: .clear, size: CGSize.zero)
        } else {
            log.error("Image not found: \(choice.choice.value)")
            super.init(texture: SKTexture(image: UIImage(named: choice.choice.value)!), color: .clear, size: CGSize.zero)
        }

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.choice.value
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var id: String
    var isDraggable: Bool = true
    var defaultPosition: CGPoint?
}
