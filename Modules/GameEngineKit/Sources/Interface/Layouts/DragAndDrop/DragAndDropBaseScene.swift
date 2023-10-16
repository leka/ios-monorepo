// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

class DragAndDropBaseScene: SKScene {
    var viewModel: GenericViewModel
    var dropAreas: [DropAreaModel]
    var biggerSide: CGFloat = 130
    var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
    var playedNode: DraggableImageAnswerNode?
    var dropAreasNode: [SKSpriteNode] = []
    private var spacer: CGFloat = .zero
    private var defaultPosition = CGPoint.zero
    private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: GenericViewModel, dropAreas: DropAreaModel...) {
        self.viewModel = viewModel
        self.dropAreas = dropAreas
        super.init(size: CGSize.zero)
        self.spacer = size.width / CGFloat(viewModel.choices.count + 1)
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        self.backgroundColor = .clear
        self.removeAllChildren()
        self.removeAllActions()

        setFirstAnswerPosition()
        layoutDropAreas()
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
            setNextAnswerPosition()

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

    func setFirstAnswerPosition() {
        spacer = size.width / CGFloat(viewModel.choices.count + 1)
        defaultPosition = CGPoint(x: spacer, y: self.size.height)
    }

    func setNextAnswerPosition() {
        self.defaultPosition.x += spacer
    }

    func layoutDropAreas() {
        for dropArea in dropAreas {
            let dropAreaNode = SKSpriteNode()
            dropAreaNode.size = dropArea.size
            dropAreaNode.texture = SKTexture(imageNamed: dropArea.file)
            dropAreaNode.position = CGPoint(x: size.width / CGFloat(dropAreas.count + 1), y: dropArea.size.height / 2)
            dropAreaNode.name = dropArea.file
            addChild(dropAreaNode)

            dropAreasNode.append(dropAreaNode)
        }
    }

    func getExpectedItems() {
        for choice in viewModel.choices where choice.rightAnswer {
            let expectedItem = choice.item
            let expectedNode = SKSpriteNode()

            guard dropAreas[0].hints else {
                expectedNode.name = expectedItem
                (expectedItemsNodes[dropAreas[0].file, default: []]).append(expectedNode)
                return
            }
            let texture = SKTexture(imageNamed: expectedItem)
            let action = SKAction.setTexture(texture, resize: true)
            expectedNode.run(action)
            expectedNode.name = expectedItem
            expectedNode.texture = texture
            expectedNode.scaleForMax(sizeOf: biggerSide * 0.8)
            expectedNode.position = CGPoint(x: dropAreasNode[0].position.x + 80, y: 110)
            (expectedItemsNodes[dropAreas[0].file, default: []]).append(expectedNode)

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
        let wiggleAnimation: SKAction = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        node.scaleForMax(sizeOf: biggerSide * 1.1)
        node.run(SKAction.repeatForever(wiggleAnimation))
    }

    func onDropAction(_ node: SKSpriteNode) {
        node.zRotation = 0
        node.removeAllActions()
        selectedNodes = [:]
    }
}
