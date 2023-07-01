// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SpriteKit

class DropAreaTwoAssetsSix: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    var gameEngine: GameEngine?
    var spacer: CGFloat = .zero
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableItemNode] = [:]
    var expectedItemsNodes = [String: [SKSpriteNode]]()
    var dropAreas: [SKSpriteNode] = []

    // internals
    let padding: CGFloat = 100

    // protocol methods
    func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = (size.width - (padding * 2)) / 5
        self.defaultPosition = CGPoint(x: padding, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    func makeDropArea() {
        makeTwoDropAreas()
        getExpectedItems()
    }

    func makeTwoDropAreas() {
        let dropArea = SKSpriteNode()
        dropArea.size = CGSize(width: 450, height: 350)
        dropArea.texture = SKTexture(imageNamed: "kitchen_assets_3")
        dropArea.position = CGPoint(x: (size.width / 2) - 275, y: 190)
        dropArea.name = "kitchen_assets_3"

        let rightSideDropArea = SKSpriteNode()
        rightSideDropArea.size = CGSize(width: 450, height: 350)
        rightSideDropArea.texture = SKTexture(imageNamed: "bathroom_assets_3")
        rightSideDropArea.position = CGPoint(x: (size.width / 2) + 275, y: 190)
        rightSideDropArea.name = "bathroom_assets_3"

        addChild(dropArea)
        addChild(rightSideDropArea)

        dropAreas = [dropArea, rightSideDropArea]
    }

    func getExpectedItems() {
        // expected answer
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
    // init
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

            let index = gameEngine!.allAnswers.firstIndex(where: { $0 == node.name })

            // dropped within the bounds of one of the dropAreas
            if node.fullyContains(bounds: dropAreas[0].frame) {
                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: dropAreas[0].name!)
                guard expectedItemsNodes[dropAreas[0].name!]!.first(where: { $0.name == node.name }) != nil else {
                    snapBack(node: node, touch: touch)
                    break
                }
                dropGoodAnswer(node)
                selectedNodes[touch] = nil
                break
            } else if node.fullyContains(bounds: dropAreas[1].frame) {
                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: dropAreas[1].name!)
                guard expectedItemsNodes[dropAreas[1].name!]!.first(where: { $0.name == node.name }) != nil else {
                    snapBack(node: node, touch: touch)
                    break
                }
                dropGoodAnswer(node)
                selectedNodes[touch] = nil
                break
            }

            // dropped outside the bounds of dropArea
            snapBack(node: node, touch: touch)
        }
    }
}
