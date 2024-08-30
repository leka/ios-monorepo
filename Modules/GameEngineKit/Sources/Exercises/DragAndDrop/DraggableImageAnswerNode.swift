// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit

class DraggableImageAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(choice: GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        guard let path = Bundle.path(forImage: choice.choice.value) else {
            fatalError("Image not found")
        }

        super.init(texture: SKTexture(image: UIImage(named: path)!), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.choice.value
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
    }

    init(choice: GameplayFindTheRightAnswersChoiceModelDragAndDropIntoZones, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        guard let path = Bundle.path(forImage: choice.choice.value) else {
            fatalError("Image not found")
        }

        super.init(texture: SKTexture(image: UIImage(named: path)!), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.choice.value
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
    }

    init(choice: GameplayDragAndDropInOrderChoiceModel, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        guard let pathImage = Bundle.path(forImage: choice.choice.value),
              let image = UIImage(named: pathImage)
        else {
            log.error("Image not found: \(choice.choice.value)")
            fatalError("💥️ Image not found: \(choice.choice.value)")
        }

        let size = image.size

        let renderer = UIGraphicsImageRenderer(size: size)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 10 / 57 * size.width)
            path.addClip()
            image.draw(in: rect)
        }

        let texture = SKTexture(image: finalImage)
        super.init(texture: texture, color: .clear, size: texture.size())

        self.name = choice.choice.value
        self.setScale(scale)
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
