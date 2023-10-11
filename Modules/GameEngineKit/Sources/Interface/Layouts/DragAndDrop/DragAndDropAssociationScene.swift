// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

class DragAndDropAssociationScene: SKScene {
    var viewModel: GenericViewModel
    var biggerSide: CGFloat = 150
    var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
    var playedNode: DraggableImageAnswerNode?
    var spacer: CGFloat = 455
    var defaultPosition = CGPoint.zero
    var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    var dropDestinations: [DraggableImageAnswerNode] = []
    private var dropDestinationAnchor: CGPoint = .zero
    private var initialNodeX: CGFloat = .zero
    private var verticalSpacing: CGFloat = .zero
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: GenericViewModel) {
        self.viewModel = viewModel
        super.init(size: CGSize.zero)
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        self.backgroundColor = .clear
        self.removeAllChildren()
        self.removeAllActions()

        dropDestinations = []

        setFirstAnswerPosition()
        makeAnswers()
    }

    func subscribeToChoicesUpdates() { 
        // Create Gameplay
        self.viewModel.$choices
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                print("receives")
                for choice in $0 where choice.item == self.playedNode?.name {
                    print(choice.item, "item")
                    if choice.status == .playingRightAnimation {
                        print("should play right anim")
                        self.goodAnswerBehavior(self.playedNode!)
                    } else if choice.status == .playingWrongAnimation {
                        print("should play wrong anim")
                        self.wrongAnswerBehavior(self.playedNode!)
                    }
                }
            })
            .store(in: &cancellables)
    }

    @MainActor func makeAnswers() {
        for (index, choice) in viewModel.choices.enumerated() {
            let draggableImageAnswerNode = DraggableImageAnswerNode(
                choice: choice,
                position: self.defaultPosition
            )
            let draggableImageShadowNode = DraggableImageShadowNode(
                draggableImageAnswerNode: draggableImageAnswerNode
            )

            normalizeAnswerNodesSize([draggableImageAnswerNode, draggableImageShadowNode])
            bindNodesToSafeArea([draggableImageAnswerNode, draggableImageShadowNode])
            setNextAnswerPosition(index)

            addChild(draggableImageShadowNode)
            addChild(draggableImageAnswerNode)

            dropDestinations.append(draggableImageAnswerNode)
        }
    }

    func normalizeAnswerNodesSize(_ nodes: [SKSpriteNode]) {
        for node in nodes {
            node.scaleForMax(sizeOf: biggerSide)
        }
    }

    func bindNodesToSafeArea(_ nodes: [SKSpriteNode], limit: CGFloat = 120) {
        let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - limit)
        let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - limit)
        for node in nodes {
            node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        }
    }

    func setFirstAnswerPosition() {
        initialNodeX = (size.width - spacer) / 2
        verticalSpacing = self.size.height / 3
        defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing - 30)
    }

    func setNextAnswerPosition(_ index: Int) {
        if [0, 2].contains(index) {
            defaultPosition.x += spacer
        } else {
            defaultPosition.x = initialNodeX
            defaultPosition.y += verticalSpacing + 60
        }
    }

    func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.position = CGPoint(
            x: dropDestinationAnchor.x - 60,
            y: dropDestinationAnchor.y - 60)
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
