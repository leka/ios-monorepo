// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit

protocol DragAndDropSceneProtocol: SKScene {
    var viewModel: GenericViewModel { get }
    var contexts: [ContextModel] { get set }
    var spacer: CGFloat { get }
    var biggerSide: CGFloat { get }
    var defaultPosition: CGPoint { get set }
    var selectedNodes: [UITouch: DraggableImageAnswerNode] { get set }
    var expectedItemsNodes: [String: [SKSpriteNode]] { get }
    var dropAreas: [SKSpriteNode] { get set }

    func reset()
    func layoutFirstAnswer()
    func makeAnswers()
    func layoutNextAnswer()
    func makeDropArea()
    func getExpectedItems()
    func dropGoodAnswer(_ node: DraggableImageAnswerNode)
    func snapBack(node: DraggableImageAnswerNode, touch: UITouch)
    func onDragAnimation(_ node: SKSpriteNode)
    func dropAction(_ node: SKSpriteNode)
}

extension DragAndDropSceneProtocol {

    var biggerSide: CGFloat { 130 }
    var dropAreas: [SKSpriteNode] { [] }

    func reset() {
        self.backgroundColor = .clear
        self.removeAllChildren()
        self.removeAllActions()

        layoutFirstAnswer()
        makeDropArea()
        getExpectedItems()
        makeAnswers()
    }

    @MainActor func makeAnswers() {
        for choice in viewModel.choices {
            let draggableImageAnswerNode = DraggableImageAnswerNode(
                choice: choice,
                position: self.defaultPosition
            )
            let draggableImageShadowNode = DraggableImageShadowNode(
                draggableImageAnswerNode: draggableImageAnswerNode
            )

            // normalize Nodes' sizes
            draggableImageAnswerNode.scaleForMax(sizeOf: biggerSide)
            draggableImageShadowNode.scaleForMax(sizeOf: biggerSide)

            // prevent Nodes from going out of bounds
            let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - 80)
            let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - 80)
            draggableImageAnswerNode.constraints = [SKConstraint.positionX(xRange, y: yRange)]
            draggableImageShadowNode.constraints = [SKConstraint.positionX(xRange, y: yRange)]

            layoutNextAnswer()

            addChild(draggableImageShadowNode)
            addChild(draggableImageAnswerNode)
        }
    }

    func makeDropArea() {
        let dropArea = SKSpriteNode()
        dropArea.size = contexts[0].size
        dropArea.texture = SKTexture(imageNamed: contexts[0].file)
        dropArea.position = CGPoint(x: size.width / 2, y: contexts[0].size.height / 2)
        dropArea.name = contexts[0].name
        addChild(dropArea)

        dropAreas.append(dropArea)
    }

    func layoutNextAnswer() {
        // spacing between items
        self.defaultPosition.x += spacer
    }

    // good answer behavior
    func dropGoodAnswer(_ node: DraggableImageAnswerNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.zPosition = 10
        node.isDraggable = false
        dropAction(node)
        // How to track endGame??
        // + below condition is for other gameplays ("...SelectAllTheGoodAnswers")
        //        if viewModel.gameplay.state.value == .finished {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.reset()
        }
        //        }
    }

    // wrong answer behavior
    func snapBack(node: DraggableImageAnswerNode, touch: UITouch) {
        let moveAnimation: SKAction = SKAction.move(to: node.defaultPosition!, duration: 0.25)
            .moveAnimation(.easeOut)
        let group: DispatchGroup = DispatchGroup()
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

    // wiggle animation
    func onDragAnimation(_ node: SKSpriteNode) {
        let sequence: SKAction = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        node.scaleForMax(sizeOf: biggerSide * 1.1)
        node.run(SKAction.repeatForever(sequence))
    }

    // remove wiggle animation
    func dropAction(_ node: SKSpriteNode) {
        node.zRotation = 0  // reset the zRotation
        node.removeAllActions()  // remove wiggle action
    }
}
