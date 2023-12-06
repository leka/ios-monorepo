// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

extension DragAndDropIntoZonesView {
    struct DropZoneNode {
        let details: DragAndDropIntoZones.DropZone.Details
        var node: SKSpriteNode = SKSpriteNode()
        let zone: DragAndDropIntoZones.DropZone
    }

    class BaseScene: SKScene {
        var viewModel: ViewModel
        var dropZoneA: DropZoneNode
        var dropZoneB: DropZoneNode?

        private var hints: Bool
        private var biggerSide: CGFloat = 130
        private var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
        private var answerNodes: [DraggableImageAnswerNode] = []
        private var playedNode: DraggableImageAnswerNode?
        private var spacer: CGFloat = .zero
        private var defaultPosition = CGPoint.zero
        private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
        private var cancellables: Set<AnyCancellable> = []

        init(
            viewModel: ViewModel, hints: Bool, dropZoneA: DragAndDropIntoZones.DropZone.Details,
            dropZoneB: DragAndDropIntoZones.DropZone.Details? = nil
        ) {
            self.viewModel = viewModel
            self.hints = hints
            self.dropZoneA = DropZoneNode(details: dropZoneA, zone: .zoneA)
            if let dropZoneB = dropZoneB {
                self.dropZoneB = DropZoneNode(details: dropZoneB, zone: .zoneB)
            }
            super.init(size: CGSize.zero)
            self.spacer = size.width / CGFloat(viewModel.choices.count + 1)
            self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

            subscribeToChoicesUpdates()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func reset() {
            self.backgroundColor = .clear
            self.removeAllChildren()
            self.removeAllActions()

            setFirstAnswerPosition()
            layoutDropZones()
            getExpectedItems()
            layoutAnswers()
        }

        func exerciseCompletedBehavior() {
            for node in answerNodes {
                node.isDraggable = false
            }
        }

        func subscribeToChoicesUpdates() {
            self.viewModel.$choices
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] choices in
                    guard let self = self else { return }

                    for choice in choices where choice.id == self.playedNode?.id {
                        if choice.state == .rightAnswer {
                            self.goodAnswerBehavior(self.playedNode!)
                        } else if choice.state == .wrongAnswer {
                            self.wrongAnswerBehavior(self.playedNode!)
                        }
                    }
                })
                .store(in: &cancellables)
        }

        @MainActor func layoutAnswers() {
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

                answerNodes.append(draggableImageAnswerNode)

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

        func layoutDropZones() {
            fatalError("layoutDropZones(dropZones:) has not been implemented")
        }

        func getExpectedItems() {
            let index = viewModel.choices.firstIndex(where: { $0.choice.dropZone == .zoneA })!
            let gameplayChoiceModel = viewModel.choices[index]
            let expectedItem = gameplayChoiceModel.choice.value
            let expectedNode = SKSpriteNode()

            guard hints else {
                expectedNode.name = expectedItem
                (expectedItemsNodes[dropZoneA.details.value, default: []]).append(expectedNode)
                return
            }
            let texture = SKTexture(image: UIImage(named: expectedItem)!)
            let action = SKAction.setTexture(texture, resize: true)
            expectedNode.run(action)
            expectedNode.name = expectedItem
            expectedNode.texture = texture
            expectedNode.scaleForMax(sizeOf: biggerSide * 0.8)
            expectedNode.position = CGPoint(x: dropZoneA.node.position.x + 80, y: 110)
            (expectedItemsNodes[dropZoneA.details.value, default: []]).append(expectedNode)

            addChild(expectedNode)
        }

        func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
            node.scaleForMax(sizeOf: biggerSide * 0.8)
            node.zPosition = 10
            node.isDraggable = false
            onDropAction(node)
            if viewModel.exercicesSharedData.state == .completed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    exerciseCompletedBehavior()
                }
            }
        }

        func wrongAnswerBehavior(_ node: DraggableImageAnswerNode) {
            let moveAnimation: SKAction = SKAction.move(to: node.defaultPosition!, duration: 0.25)
                .moveAnimation(.easeOut)
            let group: DispatchGroup = DispatchGroup()
            group.enter()
            node.scaleForMax(sizeOf: biggerSide)
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
            disableWrongAnswer(node)
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

        private func disableWrongAnswer(_ node: DraggableImageAnswerNode) {
            let gameplayChoiceModel = viewModel.choices.first(where: { $0.id == node.id })!
            if gameplayChoiceModel.choice.dropZone == nil {
                node.colorBlendFactor = 0.4
                node.isDraggable = false
            }
        }

        override func didMove(to view: SKView) {
            self.reset()
        }

        // overriden Touches states
        override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if let node = self.atPoint(location) as? DraggableImageAnswerNode {
                    for choice in viewModel.choices
                        where node.id == choice.id && node.isDraggable {
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
                guard selectedNodes.keys.contains(touch) else {
                    break
                }
                playedNode = selectedNodes[touch]!
                playedNode!.scaleForMax(sizeOf: biggerSide)
                let gameplayChoiceModel = viewModel.choices.first(where: { $0.id == playedNode!.id })

                if playedNode!.fullyContains(bounds: dropZoneA.node.frame) {
                    viewModel.onChoiceTapped(choice: gameplayChoiceModel!, dropZone: dropZoneA.zone)
                    break
                }

                if let dropZoneB = dropZoneB {
                    if playedNode!.fullyContains(bounds: dropZoneB.node.frame) {
                        viewModel.onChoiceTapped(choice: gameplayChoiceModel!, dropZone: dropZoneB.zone)
                        break
                    }
                }

                wrongAnswerBehavior(playedNode!)
            }
        }
    }
}
