// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class EmptyBasketScene: DragAndDropScene {

    private var leftSlotIsFree: Bool = true

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()
        leftSlotIsFree = true

        spacer = size.width / 4
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    override func makeDropArea() {
        dropArea.size = CGSize(width: 380, height: 280)
        dropArea.texture = SKTexture(imageNamed: "basket")
        dropArea.position = CGPoint(x: size.width / 2, y: 165)
        dropArea.name = "drop_area"
        addChild(dropArea)

        for item in gameEngine!.correctAnswersIndices {
            let expectedItem = gameEngine!.allAnswers[item]
            let expectedNode = SKSpriteNode()
            expectedNode.name = expectedItem
            expectedItemsNodes.append(expectedNode)
        }
    }

    override func dropGoodAnswer(_ node: DraggableItemNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        let finalX = setFinalXPosition()
        node.position = CGPoint(
            x: finalX,
            y: 130)
        node.zPosition = 10
        node.isDraggable = false
        if gameEngine!.allCorrectAnswersWereGiven() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.reset()
            }
        }

        func setFinalXPosition() -> CGFloat {
            guard gameEngine!.rightAnswersGiven.count < 2 else {
                return dropArea.position.x + (leftSlotIsFree ? -80 : 80)
            }
            guard endAbscissa <= size.width / 2 else {
                return dropArea.position.x + 80
            }
            if leftSlotIsFree {
                leftSlotIsFree.toggle()
            }
            return dropArea.position.x - 80
        }
    }
}
