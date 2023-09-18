// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class BasketFourScene: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    var gameEngine: GameEngine?
    var spacer: CGFloat = .zero
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableItemNode] = [:]
    var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    var dropAreas: [SKSpriteNode] = []

    // internal properties
    let padding: CGFloat = 185

    // protocol methods
    func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = (size.width - (padding * 2)) / 3
        self.defaultPosition = CGPoint(x: padding, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    func makeDropArea() {
        let dropArea = SKSpriteNode()
        dropArea.size = CGSize(width: 380, height: 280)
        dropArea.texture = SKTexture(imageNamed: "basket")
        dropArea.position = CGPoint(x: size.width / 2, y: 145)
        dropArea.name = "basket"
        addChild(dropArea)

        dropAreas.append(dropArea)

        getExpectedItems()
    }

    func getExpectedItems() {
        // expected answer(s)
        for group in gameEngine!.correctAnswersIndices {
            for item in group.value {
                let expectedItem = gameEngine!.allAnswers[item]
                let expectedNode = SKSpriteNode()
                let texture = SKTexture(imageNamed: expectedItem)
                let action = SKAction.setTexture(texture, resize: true)
                expectedNode.run(action)
                expectedNode.name = expectedItem
                expectedNode.texture = texture
                expectedNode.scaleForMax(sizeOf: biggerSide * 0.9)
                expectedNode.position = CGPoint(x: dropAreas[0].position.x + 80, y: 110)
                (expectedItemsNodes[group.key, default: []]).append(expectedNode)
                addChild(expectedNode)
            }
        }
    }

    // behaviors after trials -> right answer
    func dropGoodAnswer(_ node: DraggableItemNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.9)
        node.position = CGPoint(
            x: dropAreas[0].position.x - 80,
            y: 110)
        node.zPosition = 10
        node.isDraggable = false
        dropAction(node)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.reset()
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
