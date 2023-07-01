// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class EmptyBasketScene: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    var gameEngine: GameEngine?
    var spacer: CGFloat = .zero
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableItemNode] = [:]
    var expectedItemsNodes = [String: [SKSpriteNode]]()
    var dropAreas: [SKSpriteNode] = []

    // internal properties
    private var leftSlotIsFree: Bool = true
    private var endAbscissa: CGFloat = .zero

    // protocol methods
    func reset() {
        self.removeAllChildren()
        self.removeAllActions()
        leftSlotIsFree = true

        spacer = size.width / 4
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    func makeDropArea() {
        let dropArea = SKSpriteNode()
        dropArea.size = CGSize(width: 380, height: 280)
        dropArea.texture = SKTexture(imageNamed: "basket")
        dropArea.position = CGPoint(x: size.width / 2, y: 165)
        dropArea.name = "basket"
        addChild(dropArea)

        dropAreas.append(dropArea)

        getExpectedItems()
    }

    func getExpectedItems() {
        // expected answer(s)
        for item in gameEngine!.correctAnswersIndices["basket"]! {
            let expectedItem = gameEngine!.allAnswers[item]
            let expectedNode = SKSpriteNode()
            expectedNode.name = expectedItem
            expectedItemsNodes["basket", default: []].append(expectedNode)
        }
    }

    func dropGoodAnswer(_ node: DraggableItemNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        let finalX = setFinalXPosition()
        node.position = CGPoint(
            x: finalX,
            y: 130)
        node.zPosition = 10
        node.isDraggable = false
        dropAction(node)
        if gameEngine!.allCorrectAnswersWereGiven() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.reset()
            }
        }

        func setFinalXPosition() -> CGFloat {
            guard gameEngine!.rightAnswersGiven.count < 2 else {
                return dropAreas[0].position.x + (leftSlotIsFree ? -80 : 80)
            }
            guard endAbscissa <= size.width / 2 else {
                return dropAreas[0].position.x + 80
            }
            if leftSlotIsFree {
                leftSlotIsFree.toggle()
            }
            return dropAreas[0].position.x - 80
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
            endAbscissa = touch.location(in: self).x
            let node: DraggableItemNode = selectedNodes[touch]!
            node.scaleForMax(sizeOf: biggerSide)

            // dropped within the bounds of dropArea
            if node.fullyContains(bounds: dropAreas[0].frame) {
                let index = gameEngine!.allAnswers.firstIndex(where: { $0 == node.name })
                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: dropAreas[0].name!)
                guard expectedItemsNodes[dropAreas[0].name!, default: []].first(where: { $0.name == node.name }) != nil
                else {
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
