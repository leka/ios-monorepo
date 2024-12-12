// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI
import UtilsKit

extension DragAndDropInOrderView {
    class BaseScene: SKScene {
        // MARK: Lifecycle

        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            super.init(size: CGSize.zero)
            self.maxWidthAndHeight = 200 - 5 * CGFloat(viewModel.choices.count)
            self.spacer = size.width / CGFloat(viewModel.choices.count + 1)
            self.defaultAnswerPosition = CGPoint(x: self.spacer, y: size.height - self.padding)
            self.defaultDropZonePosition = CGPoint(x: self.spacer, y: self.padding)
            self.subscribeToChoicesUpdates()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Internal

        var viewModel: ViewModel

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
                self.playedNode!.scaleForMax(sizeOf: self.maxWidthAndHeight)
                let gameplayChoiceModel = self.viewModel.choices.first(where: { $0.id == self.playedNode!.id })

                for (index, dropZone) in self.dropZoneNodes.enumerated()
                    where self.playedNode!.fullyContains(bounds: dropZone.frame)
                {
                    self.viewModel.onChoiceDropped(choice: gameplayChoiceModel!, dropZoneIndex: index)
                    return
                }

                self.viewModel.onChoiceDroppedOutOfDropZone(choice: gameplayChoiceModel!)
            }
        }

        func reset() {
            backgroundColor = .clear
            removeAllChildren()
            removeAllActions()

            self.maxWidthAndHeight = 200 - 5 * CGFloat(self.viewModel.choices.count)
            self.spacer = size.width / CGFloat(self.viewModel.choices.count + 1)
            self.defaultAnswerPosition = CGPoint(x: self.spacer, y: size.height - self.padding)
            self.defaultDropZonePosition = CGPoint(x: self.spacer, y: self.padding)
            self.layoutNodes()
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

                    for choice in choices {
                        if let node = self.answerNodes.first(where: { $0.id == choice.id }) {
                            switch choice.state {
                                case .idle,
                                     .wrongAnswer:
                                    self.idleBehavior(node)
                                case .selected:
                                    self.selectedBehavior(node)
                                case .rightAnswer:
                                    self.goodAnswerBehavior(node)
                            }
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        @MainActor func layoutNodes() {
            for choice in self.viewModel.choices {
                let draggableImageAnswerNode = DraggableImageAnswerNode(
                    choice: choice,
                    position: defaultAnswerPosition
                )
                let draggableImageShadowNode = DraggableImageShadowNode(
                    draggableImageAnswerNode: draggableImageAnswerNode
                )
                let dropZoneNode = DropZoneNode(
                    size: CGSize(width: self.maxWidthAndHeight, height: self.maxWidthAndHeight),
                    position: self.defaultDropZonePosition
                )

                self.normalizeNodesSize([draggableImageAnswerNode, draggableImageShadowNode, dropZoneNode])
                self.bindNodesToSafeArea([draggableImageAnswerNode, draggableImageShadowNode, dropZoneNode])
                self.setNextPositions()

                self.answerNodes.append(draggableImageAnswerNode)
                self.dropZoneNodes.append(dropZoneNode)

                addChild(draggableImageShadowNode)
                addChild(draggableImageAnswerNode)
                addChild(dropZoneNode)
            }
        }

        func normalizeNodesSize(_ nodes: [SKSpriteNode]) {
            for node in nodes {
                node.scaleForMax(sizeOf: self.maxWidthAndHeight)
            }
        }

        func bindNodesToSafeArea(_ nodes: [SKSpriteNode], limit: CGFloat = 80) {
            let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - limit)
            let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - limit)
            for node in nodes {
                node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
            }
        }

        func setNextPositions() {
            self.defaultAnswerPosition.x += self.spacer
            self.defaultDropZonePosition.x += self.spacer
        }

        func idleBehavior(_ node: DraggableImageAnswerNode) {
            let moveAnimation = SKAction.move(to: node.defaultPosition!, duration: 0.25)
                .moveAnimation(.easeOut)
            let group = DispatchGroup()
            group.enter()
            node.scaleForMax(sizeOf: self.maxWidthAndHeight)
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

            node.isDraggable = true
        }

        func selectedBehavior(_ node: DraggableImageAnswerNode) {
            node.scaleForMax(sizeOf: self.maxWidthAndHeight)
            node.zPosition = 10
            for dropZone in self.dropZoneNodes where node.fullyContains(bounds: dropZone.frame) {
                node.OLDSnapToCenter(dropZone: dropZone)
                break
            }
            self.onDropAction(node)
        }

        func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
            node.isDraggable = false
            if case .completed = self.viewModel.exercicesSharedData.state {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    self.exerciseCompletedBehavior()
                }
            }
        }

        func onDragAnimation(_ node: SKSpriteNode) {
            let wiggleAnimation = SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
                SKAction.rotate(byAngle: 0.0, duration: 0.1),
                SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
            ])
            node.scaleForMax(sizeOf: self.maxWidthAndHeight * 1.1)
            node.run(SKAction.repeatForever(wiggleAnimation))
        }

        func onDropAction(_ node: SKSpriteNode) {
            node.zRotation = 0
            node.removeAllActions()
            self.selectedNodes = [:]
        }

        // MARK: Private

        private let padding: CGFloat = 120
        private var maxWidthAndHeight: CGFloat = .zero
        private var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
        private var answerNodes: [DraggableImageAnswerNode] = []
        private var dropZoneNodes: [DropZoneNode] = []
        private var playedNode: DraggableImageAnswerNode?
        private var spacer: CGFloat = .zero
        private var defaultAnswerPosition: CGPoint = .zero
        private var defaultDropZonePosition: CGPoint = .zero
        private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
        private var cancellables: Set<AnyCancellable> = []
    }
}
