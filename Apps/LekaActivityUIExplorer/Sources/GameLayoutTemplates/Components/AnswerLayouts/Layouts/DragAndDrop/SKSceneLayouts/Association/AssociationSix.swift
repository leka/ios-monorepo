// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class AssociationSix: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    var gameEngine: GameEngine?
    var spacer: CGFloat = 455  // spaces + 1 node width worth
    var biggerSide: CGFloat = 195
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableItemNode] = [:]
    var expectedItemsNodes = [String: [SKSpriteNode]]()
    var dropAreas: [SKSpriteNode] = []

    // internals
    private var initialNodeX: CGFloat = .zero
    private var verticalSpacing: CGFloat = .zero
    private var dropDestinations: [DraggableItemNode] = []
    private var dropDestinationAnchor: CGPoint = .zero

    // protocol methods
    func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        dropDestinations = []
        // FIRST: delay reset() for all Dnd Templates
        // SECOND: do Not launch another step when EndGame
        // ||-> Check that allStepsWerePlayed() -- round isn't finishing properly (cf reinforcer methods)

        makeDropArea()
        makeAnswers()
    }

    func makeDropArea() {
        // Create grid pattern's origin in this template
        initialNodeX = (size.width - spacer) / 2
        verticalSpacing = self.size.height / 3
        defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing)

        getExpectedItems()
    }

    @MainActor func makeAnswers() {
        for (index, choice) in gameEngine!.allAnswers.enumerated() {
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

            // spacing between columns and/or rows
            if [0, 2].contains(index) {
                defaultPosition.x += spacer
            } else {
                defaultPosition.x = initialNodeX
                defaultPosition.y += verticalSpacing
            }

            addChild(draggableItemShadowNode)
            addChild(draggableItemNode)

            dropDestinations.append(draggableItemNode)
        }
    }

    func getExpectedItems() {
        // expected answers
        for group in gameEngine!.correctAnswersIndices {
            for item in group.value {
                let expectedItem = gameEngine!.allAnswers[item]
                let expectedNode = SKSpriteNode()
                expectedNode.name = expectedItem
                expectedItemsNodes[group.key, default: []].append(expectedNode)
            }
        }
    }

    func dropGoodAnswer(_ node: DraggableItemNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.position = CGPoint(
            x: dropDestinationAnchor.x - 100,
            y: dropDestinationAnchor.y - 60)
        node.zPosition = 10
        node.isDraggable = false
        dropAction(node)
        if gameEngine!.allCorrectAnswersWereGiven() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.reset()
            }
        }
    }

    // MARK: - SKScene specifics
    // set/reset scene
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.reset()
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
            let node: DraggableItemNode = selectedNodes[touch]!
            node.scaleForMax(sizeOf: biggerSide)

            // make dropArea out of target node
            let dropAreaIndex = dropDestinations.firstIndex(where: {
                $0.frame.contains(touch.location(in: self)) && $0.name != node.name
            })

            // dropped outside the bounds of any dropArea
            guard dropAreaIndex != nil else {
                snapBack(node: node, touch: touch)
                break
            }

            let dropArea = dropDestinations[dropAreaIndex!]
            dropDestinationAnchor = dropArea.position

            // define contexts
            var rightContext = String()
            var wrongContext = String()
            for context in expectedItemsNodes {
                for item in context.value where item.name == node.name {
                    rightContext = context.key
                }
            }
            for context in expectedItemsNodes where context.key != rightContext {
                wrongContext = context.key
            }

            let index = gameEngine!.allAnswers.firstIndex(where: { $0 == node.name })
            let destinationIndex = gameEngine!.allAnswers.firstIndex(where: { $0 == dropArea.name })

            guard (gameEngine?.correctAnswersIndices[rightContext, default: []].contains(destinationIndex!))!
            else {
                // dropped within the bounds of the wrong sibling
                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: wrongContext)
                snapBack(node: node, touch: touch)
                break
            }
            // dropped within the bounds of the proper sibling
            dropDestinations[dropAreaIndex!].isDraggable = false
            gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: rightContext)
            gameEngine?.answerHasBeenGiven(atIndex: destinationIndex!, withinContext: rightContext)
            dropGoodAnswer(node)
            selectedNodes[touch] = nil
            break
        }
    }
}
