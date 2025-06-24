// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI
import UtilsKit

extension DragAndDropIntoZonesView {
    struct DropZoneNode {
        let details: DragAndDropIntoZones.DropZone.Details
        var node: SKSpriteNode = .init()
        let zone: DragAndDropIntoZones.DropZone
    }

    class BaseScene: SKScene {
        // MARK: Lifecycle

        init(
            viewModel: ViewModel, hints: Bool, dropZoneA: DragAndDropIntoZones.DropZone.Details,
            dropZoneB: DragAndDropIntoZones.DropZone.Details? = nil
        ) {
            self.viewModel = viewModel
            self.hints = hints
            self.dropZoneA = DropZoneNode(details: dropZoneA, zone: .zoneA)
            if let dropZoneB {
                self.dropZoneB = DropZoneNode(details: dropZoneB, zone: .zoneB)
            }
            super.init(size: CGSize.zero)
            self.spacer = size.width / CGFloat(viewModel.choices.count + 1)
            self.defaultPosition = CGPoint(x: self.spacer, y: size.height)

            self.subscribeToChoicesUpdates()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Internal

        var viewModel: ViewModel
        var dropZoneA: DropZoneNode
        var dropZoneB: DropZoneNode?

        override func didMove(to _: SKView) {
            self.reset()
        }

        // overriden Touches states
        override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if let node = atPoint(location) as? DraggableImageAnswerNode {
                    for choice in self.viewModel.choices
                        where node.id == choice.id && node.isDraggable
                    {
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
                    let bounds: CGRect = view!.bounds
                    if node.fullyContains(location: location, bounds: bounds) {
                        node.position = location
                    } else {
                        self.touchesEnded(touches, with: event)
                    }
                }
            }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
            for touch in touches {
                guard self.selectedNodes.keys.contains(touch) else {
                    break
                }
                self.playedNode = self.selectedNodes[touch]!
                self.playedNode!.scaleForMax(sizeOf: self.biggerSide)
                let gameplayChoiceModel = self.viewModel.choices.first(where: { $0.id == self.playedNode!.id })

                if self.playedNode!.fullyContains(bounds: self.dropZoneA.node.frame) {
                    self.viewModel.onChoiceDropped(choice: gameplayChoiceModel!, into: self.dropZoneA.zone)
                    break
                }

                if let dropZoneB, self.playedNode!.fullyContains(bounds: dropZoneB.node.frame) {
                    self.viewModel.onChoiceDropped(choice: gameplayChoiceModel!, into: dropZoneB.zone)
                    break
                }

                self.wrongAnswerBehavior(self.playedNode!)
            }
        }

        func reset() {
            backgroundColor = .clear
            removeAllChildren()
            removeAllActions()

            self.setFirstAnswerPosition()
            self.layoutDropZones()
            self.layoutAnswers()
        }

        func exerciseCompletedBehavior() {
            for node in self.answerNodes {
                node.isDraggable = false
            }
        }

        func subscribeToChoicesUpdates() {
            self.viewModel.$choices
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] choices in
                    guard let self else { return }

                    for choice in choices where choice.id == self.playedNode?.id {
                        if choice.state == .rightAnswer {
                            self.goodAnswerBehavior(self.playedNode!)
                        } else if choice.state == .wrongAnswer {
                            self.wrongAnswerBehavior(self.playedNode!)
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        @MainActor func layoutAnswers() {
            for choice in self.viewModel.choices {
                let draggableImageAnswerNode = DraggableImageAnswerNode(
                    choice: choice,
                    position: defaultPosition
                )
                let draggableImageShadowNode = DraggableImageShadowNode(
                    draggableImageAnswerNode: draggableImageAnswerNode
                )

                self.normalizeAnswerNodesSize([draggableImageAnswerNode, draggableImageShadowNode])
                self.bindNodesToSafeArea([draggableImageAnswerNode, draggableImageShadowNode])
                self.setNextAnswerPosition()

                self.answerNodes.append(draggableImageAnswerNode)

                addChild(draggableImageShadowNode)
                addChild(draggableImageAnswerNode)
            }
        }

        func normalizeAnswerNodesSize(_ nodes: [SKSpriteNode]) {
            for node in nodes {
                node.scaleForMax(sizeOf: self.biggerSide)
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
            self.spacer = size.width / CGFloat(self.viewModel.choices.count + 1)
            self.defaultPosition = CGPoint(x: self.spacer, y: size.height)
        }

        func setNextAnswerPosition() {
            self.defaultPosition.x += self.spacer
        }

        func layoutDropZones() {
            fatalError("layoutDropZones(dropZones:) has not been implemented")
        }

        func getExpectedItems() {
            let index = self.viewModel.choices.firstIndex(where: { $0.choice.dropZone == .zoneA })!
            let gameplayChoiceModel = self.viewModel.choices[index]
            let expectedItem = gameplayChoiceModel.choice.value
            let expectedNode = SKSpriteNode()

            guard self.hints else {
                expectedNode.name = expectedItem
                (self.expectedItemsNodes[self.dropZoneA.details.value, default: []]).append(expectedNode)
                return
            }
            let texture = SKTexture(image: UIImage(named: expectedItem)!)
            let action = SKAction.setTexture(texture, resize: true)
            expectedNode.run(action)
            expectedNode.name = expectedItem
            expectedNode.texture = texture
            expectedNode.scaleForMax(sizeOf: self.biggerSide * 0.8)
            expectedNode.position = CGPoint(x: self.dropZoneA.node.position.x + 80, y: 110)
            self.expectedItemsNodes[self.dropZoneA.details.value, default: []].append(expectedNode)

            addChild(expectedNode)
        }

        func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
            node.scaleForMax(sizeOf: self.biggerSide)
            node.zPosition = 10
            if node.fullyContains(bounds: self.dropZoneA.node.frame) {
                node.OLDRepositionInside(dropZone: self.dropZoneA.node)
            } else if let dropZoneB, node.fullyContains(bounds: dropZoneB.node.frame) {
                node.OLDRepositionInside(dropZone: dropZoneB.node)
            }
            node.isDraggable = false
            self.onDropAction(node)
            if case .completed = self.viewModel.exercicesSharedData.state {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    self.exerciseCompletedBehavior()
                }
            }
        }

        func wrongAnswerBehavior(_ node: DraggableImageAnswerNode) {
            let moveAnimation = SKAction.move(to: node.defaultPosition!, duration: 0.25)
                .moveAnimation(.easeOut)
            let group = DispatchGroup()
            group.enter()
            node.scaleForMax(sizeOf: self.biggerSide)
            node.run(
                moveAnimation,
                completion: {
                    node.position = node.defaultPosition!
                    node.zPosition = 10
                    group.leave()
                }
            )
            group.notify(queue: .main) {
                self.onDropAction(node)
            }
            self.disableWrongAnswer(node)
        }

        func onDragAnimation(_ node: SKSpriteNode) {
            let wiggleAnimation = SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
                SKAction.rotate(byAngle: 0.0, duration: 0.1),
                SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
            ])
            node.scaleForMax(sizeOf: self.biggerSide * 1.1)
            node.run(SKAction.repeatForever(wiggleAnimation))
        }

        func onDropAction(_ node: SKSpriteNode) {
            node.zRotation = 0
            node.removeAllActions()
            self.selectedNodes = [:]
        }

        // MARK: Private

        private var hints: Bool
        private var biggerSide: CGFloat = 140
        private var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
        private var answerNodes: [DraggableImageAnswerNode] = []
        private var playedNode: DraggableImageAnswerNode?
        private var spacer: CGFloat = .zero
        private var defaultPosition = CGPoint.zero
        private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
        private var cancellables: Set<AnyCancellable> = []

        private func disableWrongAnswer(_ node: DraggableImageAnswerNode) {
            let gameplayChoiceModel = self.viewModel.choices.first(where: { $0.id == node.id })!
            if gameplayChoiceModel.choice.dropZone == nil {
                node.colorBlendFactor = 0.4
                node.isDraggable = false
            }
        }
    }
}
