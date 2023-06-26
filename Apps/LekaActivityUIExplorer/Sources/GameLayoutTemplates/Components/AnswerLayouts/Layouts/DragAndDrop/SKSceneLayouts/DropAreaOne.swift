// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class DropAreaOne: DragAndDropScene {

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = size.width / 2
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    override func makeDropArea() {
        dropArea.size = CGSize(width: 450, height: 350)
        dropArea.texture = SKTexture(imageNamed: "kitchen_asset_1")
        dropArea.position = CGPoint(x: size.width / 2, y: 190)
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
        node.zPosition = 10
        node.isDraggable = false
        if gameEngine!.allCorrectAnswersWereGiven() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.reset()
            }
        }
    }
}
