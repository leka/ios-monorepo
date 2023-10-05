// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

protocol DragAndDropSceneProtocol: SKScene {
    var viewModel: GenericViewModel { get set }
    var contexts: [ContextViewModel]? { get set }
    var spacer: CGFloat { get }
    var biggerSide: CGFloat { get }
    var defaultPosition: CGPoint { get set }
    var selectedNodes: [UITouch: DraggableImageAnswerNode] { get set }
    var playedNode: DraggableImageAnswerNode? { get set }
    var expectedItemsNodes: [String: [SKSpriteNode]] { get set }
    var dropAreas: [SKSpriteNode] { get set }
    var cancellables: Set<AnyCancellable> { get set }

    func reset()
    func subscribeToChoicesUpdates()
    func layoutFirstAnswer()
    func makeAnswers()
    func normalizeAnswerNodesSize(_ nodes: [SKSpriteNode])
    func bindNodesToSafeArea(_ nodes: [SKSpriteNode], limit: CGFloat)
    func layoutNextAnswer()
    func makeDropArea()
    func getExpectedItems()
    func goodAnswerBehavior(_ node: DraggableImageAnswerNode)
    func wrongAnswerBehavior(_ node: DraggableImageAnswerNode)
    func onDragAnimation(_ node: SKSpriteNode)
    func onDropAction(_ node: SKSpriteNode)
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

    func subscribeToChoicesUpdates() {
        self.viewModel.$choices
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                for choice in $0 where choice.item == self.playedNode?.name {
                    if choice.status == .playingRightAnimation {
                        self.goodAnswerBehavior(self.playedNode!)
                    } else if choice.status == .playingWrongAnimation {
                        self.wrongAnswerBehavior(self.playedNode!)
                    }
                }
            })
            .store(in: &cancellables)
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

            normalizeAnswerNodesSize([draggableImageAnswerNode, draggableImageShadowNode])
            bindNodesToSafeArea([draggableImageAnswerNode, draggableImageShadowNode])
            layoutNextAnswer()

            addChild(draggableImageShadowNode)
            addChild(draggableImageAnswerNode)
        }
    }

    func normalizeAnswerNodesSize(_ nodes: [SKSpriteNode]) {
        for node in nodes {
            node.scaleForMax(sizeOf: biggerSide)
        }
    }

    func bindNodesToSafeArea(_ nodes: [SKSpriteNode], limit: CGFloat = 80) {
        let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - limit)
        let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - limit)
        for node in nodes {
            node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        }
    }

    func layoutNextAnswer() {
        self.defaultPosition.x += spacer
    }

    func makeDropArea() {
        guard let currentContexts = contexts else {
            return
        }
        let dropArea = SKSpriteNode()
        dropArea.size = currentContexts[0].size
        dropArea.texture = SKTexture(imageNamed: currentContexts[0].file)
        dropArea.position = CGPoint(x: size.width / 2, y: currentContexts[0].size.height / 2)
        dropArea.name = currentContexts[0].file
        addChild(dropArea)

        dropAreas.append(dropArea)
    }

    func getExpectedItems() {
        for choice in viewModel.choices where choice.rightAnswer {
            let expectedItem = choice.item
            let expectedNode = SKSpriteNode()

            guard let currentContexts = contexts else {
                return
            }
            guard currentContexts[0].hints else {
                expectedNode.name = expectedItem
                (expectedItemsNodes[currentContexts[0].file, default: []]).append(expectedNode)
                return
            }
            let texture = SKTexture(imageNamed: expectedItem)
            let action = SKAction.setTexture(texture, resize: true)
            expectedNode.run(action)
            expectedNode.name = expectedItem
            expectedNode.texture = texture
            expectedNode.scaleForMax(sizeOf: biggerSide * 0.8)
            expectedNode.position = CGPoint(x: dropAreas[0].position.x + 80, y: 110)
            (expectedItemsNodes[currentContexts[0].file, default: []]).append(expectedNode)

            addChild(expectedNode)
        }
    }

    func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.zPosition = 10
        node.isDraggable = false
        onDropAction(node)
        if viewModel.gameplay.state.value == .finished {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                self.reset()
            }
        }
    }

    func wrongAnswerBehavior(_ node: DraggableImageAnswerNode) {
        let moveAnimation: SKAction = SKAction.move(to: node.defaultPosition!, duration: 0.25)
            .moveAnimation(.easeOut)
        let group: DispatchGroup = DispatchGroup()
        group.enter()
        node.run(
            moveAnimation,
            completion: {
                node.position = node.defaultPosition!
                node.zPosition = 10
                group.leave()
            })
        group.notify(queue: .main) {
            self.onDropAction(node)
        }
    }

    func onDragAnimation(_ node: SKSpriteNode) {
        let sequence: SKAction = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        node.scaleForMax(sizeOf: biggerSide * 1.1)
        node.run(SKAction.repeatForever(sequence))
    }

    func onDropAction(_ node: SKSpriteNode) {
        node.zRotation = 0
        node.removeAllActions()
        selectedNodes = [:]
    }
}
