// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

class DragAndDropOneAreaOneChoiceScene: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    //    var gameEngine: GameEngine?
    //    var viewModel: GenericViewModel?
    var choices: [ChoiceViewModel]
    var contexts: [ContextModel]
    var spacer: CGFloat = .zero
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
    var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    var dropAreas: [SKSpriteNode] = []

    public init(choices: [ChoiceViewModel], contexts: [ContextModel]) {
        self.choices = choices
        self.contexts = contexts
        super.init(size: CGSize.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // protocol methods
    func reset() {
        self.removeAllChildren()
        self.removeAllActions()

        spacer = size.width / 2
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        makeDropArea()
        makeAnswers()
    }

    // Make the following a standalone View
    // put size as parameter
    func makeDropArea() {
        let dropArea = SKSpriteNode()
        dropArea.size = CGSize(width: 380, height: 280)
        dropArea.texture = SKTexture(imageNamed: "basket")
        dropArea.position = CGPoint(x: size.width / 2, y: 145)  // y: dropArea.size.height/2 + 5
        dropArea.name = "basket"
        addChild(dropArea)

        dropAreas.append(dropArea)

        getExpectedItems()
    }

    // Include this within the makeDroppAreaView above...
    // there is a version of this without added child (like empty basket etc...)
    // AND a version where I just get the expected answers
    // This just need the correct Answers from the Choices
    // Maybe don't put the entire gameEngine replacement
    func getExpectedItems() {
        // expected answer(s)
        for choice in choices where choice.rightAnswer {
            let expectedItem = choice.item
            let expectedNode = SKSpriteNode()
            let texture = SKTexture(imageNamed: expectedItem)
            let action = SKAction.setTexture(texture, resize: true)
            expectedNode.run(action)
            expectedNode.name = expectedItem
            expectedNode.texture = texture
            expectedNode.scaleForMax(sizeOf: biggerSide * 0.9)
            expectedNode.position = CGPoint(x: dropAreas[0].position.x + 80, y: 110)
            (expectedItemsNodes[contexts[0].name, default: []]).append(expectedNode)
            addChild(expectedNode)
        }
    }

    // behaviors after trials -> right answer
    // drop good answer placed ...
    // for now just use a version without placement (keep track of the rest for later or options)
    // add this implementation to the protocol (same for all for now)
    func dropGoodAnswer(_ node: DraggableImageAnswerNode) {
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
    // this just needs the Choices, not the entire GameEngine
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? DraggableImageAnswerNode {
                for choice in choices where node.name == choice.item && node.isDraggable {
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

    // this just needs the Choices, not the entire GameEngine
    // answerHasBeenGiven should be replaced with the behavior triggers from Hugo's work
    override func touchesEnded(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch in touches {
            if !selectedNodes.keys.contains(touch) {
                break
            }
            let node: DraggableImageAnswerNode = selectedNodes[touch]!
            node.scaleForMax(sizeOf: biggerSide)

            // dropped within the bounds of dropArea
            if node.fullyContains(bounds: dropAreas[0].frame) {
                let index = choices.firstIndex(where: { $0.item == node.name })
                //                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: dropAreas[0].name!)
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
