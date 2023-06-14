// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DragAndDropScene: SKScene {

    var gameEngine: GameEngine?

    var spacer: CGFloat = .zero
    var biggerSide: CGFloat = 170
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableItemNode] = [:]
    var endAbscissa: CGFloat = .zero
    var expectedItemsNodes = [SKSpriteNode]()
    var dropArea = SKSpriteNode()

    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.reset()
    }

    func makeAnswers() {
        for choice in gameEngine!.allAnswers {
            let draggableItemNode: DraggableItemNode = DraggableItemNode(
                texture: SKTexture(imageNamed: choice),
                name: choice,
                position: self.defaultPosition)
            let draggableItemShadowNode: DraggableItemShadowNode = DraggableItemShadowNode(
                draggableItemNode: draggableItemNode)

            // normalize Nodes' sizes
            draggableItemNode.scaleForMax(sizeOf: biggerSide)
            draggableItemShadowNode.scaleForMax(sizeOf: biggerSide)

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
    }

    func makeDropArea() {
        // for destination in gameEngine!.destinations {
        // let destination = SKSpriteNode()
        // ...
        dropArea.size = CGSize(width: 380, height: 280)
        dropArea.texture = SKTexture(imageNamed: "basket")
        dropArea.position = CGPoint(x: size.width / 2, y: 165)
        dropArea.name = "drop_area"
        addChild(dropArea)

        // expected answer
        let expectedItem = gameEngine!.allAnswers[gameEngine!.correctAnswersIndices[0]]
        let texture = SKTexture(imageNamed: expectedItem)
        let action = SKAction.setTexture(texture, resize: true)
        expectedItemsNodes.append(SKSpriteNode())
        expectedItemsNodes[0].run(action)
        expectedItemsNodes[0].name = expectedItem
        expectedItemsNodes[0].texture = texture
        expectedItemsNodes[0].scaleForMax(sizeOf: biggerSide * 0.8)
        expectedItemsNodes[0].position = CGPoint(x: dropArea.position.x + 80, y: 130)

        addChild(expectedItemsNodes[0])
    }

    func reset() {
        // implementation within each template
    }

    // behaviors after trials -> right answer
    func dropGoodAnswer(_ node: DraggableItemNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.position = CGPoint(
            x: dropArea.position.x - 80,
            y: 130)
        node.zPosition = 10
        node.isDraggable = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.reset()
        }
    }

    // wiggle animation
    private func onDragAnimation(_ node: SKSpriteNode) {
        let sequence: SKAction = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        node.scaleForMax(sizeOf: biggerSide * 1.1)
        node.run(SKAction.repeatForever(sequence))
    }

    // overriden Touches states
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
            endAbscissa = touch.location(in: self).x
            let node: DraggableItemNode = selectedNodes[touch]!
            let moveAnimation: SKAction = SKAction.move(to: node.defaultPosition!, duration: 0.25)
                .moveAnimation(.easeOut)
            let group: DispatchGroup = DispatchGroup()
            node.scaleForMax(sizeOf: biggerSide)

            // dropped within the bounds of dropArea
            if node.fullyContains(bounds: dropArea.frame) {
                let index = gameEngine!.allAnswers.firstIndex(where: { $0 == node.name })
                gameEngine?.answerHasBeenPressed(atIndex: index!)
                guard let _ = expectedItemsNodes.first(where: { $0.name == node.name }) else {
                    snapBack()
                    break
                }
                dropGoodAnswer(node)
                selectedNodes[touch] = nil
                dropAction(node)
                break
            }

            // dropped outside the bounds of dropArea
            snapBack()

            // behaviors after trials -> wrong answer
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
                    dropAction(node)
                }
                selectedNodes[touch] = nil
            }

            func dropAction(_ node: SKSpriteNode) {
                node.zRotation = 0  // reset the zRotation
                node.removeAllActions()  // remove wiggle action
            }
        }
    }
}
