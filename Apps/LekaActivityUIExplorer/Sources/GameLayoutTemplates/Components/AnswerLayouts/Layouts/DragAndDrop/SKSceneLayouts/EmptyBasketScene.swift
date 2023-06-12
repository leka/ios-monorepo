// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class EmptyBasketScene: DragAndDropScene {

    override func reset() {
        self.removeAllChildren()
        self.removeAllActions()

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

        // expected answer
        //        let expectedItem = gameEngine!.allAnswers[gameEngine!.correctAnswerIndex]
        //        let texture = SKTexture(imageNamed: expectedItem)
        //        let action = SKAction.setTexture(texture, resize: true)
        //        expectedItemNode.append(SKSpriteNode())
        //        expectedItemNode[0].run(action)
        //        expectedItemNode[0].name = expectedItem
        //        expectedItemNode[0].texture = texture
        //        expectedItemNode[0].scaleForMax(sizeOf: biggerSide * 0.8)
        //        expectedItemNode[0].position = CGPoint(x: dropArea.position.x + 80, y: 130)
        //
        //        addChild(expectedItemNode[0])
    }
}
