// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DragAndDropScene: SKScene {

    var gameEngine: GameEngine?

    var expectedItemNode: SKSpriteNode = SKSpriteNode()
    var spacer: CGFloat = .zero
    var defaultPosition = CGPoint.zero
    var dropArea = SKSpriteNode()
    var selectedNodes: [UITouch: DraggableItemNode] = [:]

    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.reset()
    }

    func reset() {
        self.removeAllChildren()
        self.removeAllActions()
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        // size, position and texture moved to SKView (DragAndDropView)
        dropArea.name = "drop_area"

        addChild(dropArea)

        for choice in gameEngine!.allAnswers {
            let draggableItemNode: DraggableItemNode = DraggableItemNode(
                texture: SKTexture(imageNamed: choice),
                name: choice,
                position: self.defaultPosition)
            let draggableItemShadowNode: DraggableItemShadowNode = DraggableItemShadowNode(
                draggableItemNode: draggableItemNode)

            // normalize Nodes' sizes
            draggableItemNode.scaleForMax(sizeOf: 170)
            draggableItemShadowNode.scaleForMax(sizeOf: 170)

            // prevent Nodes from going out of bounds
            let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - 120)
            let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - 120)
            draggableItemNode.constraints = [SKConstraint.positionX(xRange, y: yRange)]
            draggableItemShadowNode.constraints = [SKConstraint.positionX(xRange, y: yRange)]

            // spacing between items
            self.defaultPosition.x += spacer

            addChild(draggableItemShadowNode)
            addChild(draggableItemNode)
        }

        // expected answer
        let expectedItem = gameEngine!.allAnswers[gameEngine!.correctAnswerIndex]
        let texture = SKTexture(imageNamed: expectedItem)
        let action = SKAction.setTexture(texture, resize: true)
        expectedItemNode.run(action)
        expectedItemNode.name = expectedItem
        expectedItemNode.texture = texture
        expectedItemNode.scaleForMax(sizeOf: 136)
        expectedItemNode.position = CGPoint(x: dropArea.position.x + 80, y: 130)

        addChild(expectedItemNode)
    }

    func onDragAnimation(_ node: SKSpriteNode) {
        let sequence: SKAction = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        node.scaleForMax(sizeOf: 187)
        node.run(SKAction.repeatForever(sequence))
    }

    func dropAction(_ node: SKSpriteNode) {
        node.zRotation = 0  // Reset the zRotation
        node.removeAllActions()  // Remove wiggle action
    }

    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? DraggableItemNode {
                for choice in gameEngine!.allAnswers where node.name == choice && node.isDraggable {
                    selectedNodes[touch] = node
                    onDragAnimation(node)
                    node.zPosition += 100
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = selectedNodes[touch] {
                let bounds: CGRect = self.view!.bounds
                if node.fullyContains(location: location, bounds: bounds) {
                    node.run(SKAction.move(to: location, duration: 0.05).moveAnimation(.linear))
                    node.position = location
                } else {
                    self.touchesEnded(touches, with: event)
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch in touches {
            if !selectedNodes.keys.contains(touch) {
                break
            }

            let node: DraggableItemNode = selectedNodes[touch]!
            let moveAnimation: SKAction = SKAction.move(to: node.defaultPosition!, duration: 0.25)
                .moveAnimation(.easeOut)
            let group: DispatchGroup = DispatchGroup()
            node.scaleForMax(sizeOf: 170)

            // dropped within the bounds of dropArea
            if node.fullyContains(bounds: dropArea.frame) {
                let index = gameEngine!.allAnswers.firstIndex(where: { $0 == node.name })
                gameEngine?.answerHasBeenPressed(atIndex: index!)
                guard node.name == expectedItemNode.name else {
                    snapBack()
                    break
                }
                dropGoodAnswer()
                break
            }

            // dropped outside the bounds of dropArea
            snapBack()

            // Behaviors after trials
            func snapBack() {
                group.enter()
                node.run(
                    moveAnimation,
                    completion: {
                        node.position = node.defaultPosition!
                        node.zPosition -= 100
                        group.leave()
                    })
                group.notify(queue: .main) {
                    self.dropAction(node)
                }
                selectedNodes[touch] = nil
            }

            func dropGoodAnswer() {
                node.scaleForMax(sizeOf: 136)
                node.position = CGPoint(
                    x: dropArea.position.x - 80,
                    y: 130)
                node.zPosition = 10
                node.isDraggable = false
                selectedNodes[touch] = nil
                dropAction(node)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.reset()
                }
            }
        }
    }
}
