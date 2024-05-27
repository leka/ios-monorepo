// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit

class DraggableImageAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(choice: any GameplayChoiceModelProtocol, scale: CGFloat = 1, position: CGPoint) {
        self.id = choice.id

        var name: String

        if let associateChoiceModel = choice as? GameplayAssociateCategoriesChoiceModel {
            name = associateChoiceModel.choice.value
        } else if let intoZonesChoiceModel = choice as? GameplayDragAndDropIntoZonesChoiceModel {
            name = intoZonesChoiceModel.choice.value
        } else {
            fatalError("Current ChoiceModel is not supported by DraggableImageAnswerNode")
        }

        guard let path = Bundle.path(forImage: choice.choice.value) else {
            fatalError("Image not found")
        }

        super.init(texture: SKTexture(image: UIImage(named: path)!), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

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
