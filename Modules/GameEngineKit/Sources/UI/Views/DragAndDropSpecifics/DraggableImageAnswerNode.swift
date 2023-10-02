// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DraggableImageAnswerNode: SKSpriteNode {

    var isDraggable: Bool = true
    var defaultPosition: CGPoint?
    var status: ChoiceState?

    init(choice: ChoiceViewModel, scale: CGFloat = 1, position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: choice.item), color: .clear, size: CGSize.zero)

        let action = SKAction.setTexture(texture!, resize: true)
        self.run(action)

        self.name = choice.item
        self.texture = texture
        self.setScale(scale)
        self.size = size
        self.position = position
        self.defaultPosition = position
        self.status = choice.status
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func snapBack() {
        let moveAnimation: SKAction = SKAction.move(to: self.defaultPosition!, duration: 0.25)
            .moveAnimation(.easeOut)
        let group: DispatchGroup = DispatchGroup()
        group.enter()
        self.run(
            moveAnimation,
            completion: {
                self.position = self.defaultPosition!
                self.zPosition -= 100
                group.leave()
            })
        group.notify(queue: .main) {
            self.dropAction()
        }
    }

    // remove wiggle animation .notSelected??
    func dropAction() {
        self.zRotation = 0  // reset the zRotation
        self.removeAllActions()  // remove wiggle action
    }
}
