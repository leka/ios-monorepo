// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class DropAreaTwoAssetOne: DragAndDropScene {

    var rightSideDropArea = SKSpriteNode()

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
        dropArea.position = CGPoint(x: (size.width / 2) - 275, y: 190)
        dropArea.name = "left_side_drop_area"

        rightSideDropArea.size = CGSize(width: 450, height: 350)
        rightSideDropArea.texture = SKTexture(imageNamed: "bathroom_asset_1")
        rightSideDropArea.position = CGPoint(x: (size.width / 2) + 275, y: 190)
        rightSideDropArea.name = "left_side_drop_area"

        addChild(dropArea)
        addChild(rightSideDropArea)

        for item in gameEngine!.correctAnswersIndices[0] {
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
