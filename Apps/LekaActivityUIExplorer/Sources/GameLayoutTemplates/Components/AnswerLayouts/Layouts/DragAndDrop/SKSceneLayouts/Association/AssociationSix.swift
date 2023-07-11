// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class AssociationSix: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    var gameEngine: GameEngine?
    var spacer: CGFloat = 375
    var biggerSide: CGFloat = 195
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableItemNode] = [:]
    var expectedItemsNodes = [String: [SKSpriteNode]]()

    // internals
    private var initialNodeX: CGFloat = .zero
    private var verticalSpacing: CGFloat = .zero
    private var dropDestinations: [DraggableItemNode] = []
    private var answersTurnedToDropAreas: [String: DraggableItemNode] = [:]
    private var answeredButNotTurnedToDropArea: [Int] = []
    // answers layout
    private var dropDestinationAnchor: CGPoint = .zero
    private var freeSlots: [String: [Bool]] = [:]
    private var endAbscissa: CGFloat = .zero
    private var finalXPosition: CGFloat = .zero

    // protocol methods
    func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        dropDestinations = []
        answersTurnedToDropAreas = [:]
        answeredButNotTurnedToDropArea = []
        freeSlots = [:]

        makeDropArea()
        makeAnswers()
    }

    func makeDropArea() {
        // Create grid pattern's origin in this template
        initialNodeX = (size.width - (spacer * 2)) / 2
        verticalSpacing = self.size.height / 3
        defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing)

        getExpectedItems()
    }

    func getExpectedItems() {
        // expected answers
        for group in gameEngine!.correctAnswersIndices {
            for item in group.value {
                let expectedItem = gameEngine!.allAnswers[item]
                let expectedNode = SKSpriteNode()
                expectedNode.name = expectedItem
                expectedItemsNodes[group.key, default: []].append(expectedNode)
                freeSlots[group.key] = [true, true]
            }
        }
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
            if [0, 1, 3, 4].contains(index) {
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

    func dropGoodAnswer(_ node: DraggableItemNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.position = CGPoint(
            x: finalXPosition,
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

    // prepare answer's layout
    private func setFinalXPosition(context: String) {
        guard endAbscissa <= dropDestinationAnchor.x else {
            finalXPosition = {
                guard freeSlots[context]![1] else {
                    freeSlots[context]![0] = false
                    return dropDestinationAnchor.x - 100
                }
                freeSlots[context]![1] = false
                return dropDestinationAnchor.x + 100
            }()
            return
        }
        finalXPosition = {
            guard freeSlots[context]![0] else {
                freeSlots[context]![1] = false
                return dropDestinationAnchor.x + 100
            }
            freeSlots[context]![0] = false
            return dropDestinationAnchor.x - 100
        }()
    }

    // get adequat contexts for currently evaluated answer
    private func getRightContext(node: DraggableItemNode) -> String {
        var contextName = String()
        for context in expectedItemsNodes {
            for item in context.value where item.name == node.name {
                contextName = context.key
            }
        }
        return contextName
    }

    private func getWrongContext(comparedTo: String) -> String {
        var contextName = String()
        for context in expectedItemsNodes where context.key != comparedTo {
            contextName = context.key
        }
        return contextName
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

            // make dropArea out of destination touch
            let dropAreaIndex = dropDestinations.firstIndex(where: {
                $0.frame.contains(touch.location(in: self)) && $0.name != node.name
            })
            guard let newDestinationIndex = dropAreaIndex else {
                // dropped outside the bounds of any dropArea
                snapBack(node: node, touch: touch)
                break
            }
            let dropArea = dropDestinations[newDestinationIndex]

            // define contexts
            let rightContext = getRightContext(node: node)
            let wrongContext = getWrongContext(comparedTo: rightContext)

            // define played indices (answer + dropArea)
            let index = gameEngine!.allAnswers.firstIndex(where: { $0 == node.name })
            let destinationIndex = gameEngine!.allAnswers.firstIndex(where: { $0 == dropArea.name })

            // play in given context
            guard (gameEngine?.correctAnswersIndices[rightContext, default: []].contains(destinationIndex!))!
            else {
                // dropped within the wrong context
                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: wrongContext)
                snapBack(node: node, touch: touch)
                break
            }
            dropDestinations[newDestinationIndex].isDraggable = false
            gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: rightContext)
            gameEngine?.answerHasBeenGiven(atIndex: destinationIndex!, withinContext: rightContext)

            // dropped within the bounds of some proper sibling + keep track of answer
            endAbscissa = touch.location(in: self).x
            guard !answeredButNotTurnedToDropArea.contains(newDestinationIndex) else {
                // a dropArea already exists in this context
                dropDestinationAnchor = answersTurnedToDropAreas[rightContext]!.position
                setFinalXPosition(context: rightContext)

                // layout answer
                dropGoodAnswer(node)
                selectedNodes[touch] = nil
                break
            }
            // no dropAreas exist yet in this context
            let nodeIndex = dropDestinations.firstIndex(where: { $0.name == node.name })
            answeredButNotTurnedToDropArea.append(nodeIndex!)
            answersTurnedToDropAreas[rightContext] = dropArea
            dropDestinationAnchor = dropArea.position
            setFinalXPosition(context: rightContext)

            // layout answer
            dropGoodAnswer(node)
            selectedNodes[touch] = nil
        }
    }
}
