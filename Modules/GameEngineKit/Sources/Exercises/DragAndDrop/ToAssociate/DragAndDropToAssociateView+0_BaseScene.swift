// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI
import UtilsKit

extension DragAndDropToAssociateView {
    class BaseScene: SKScene {
        // MARK: Lifecycle

        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            super.init(size: CGSize.zero)

            self.subscribeToChoicesUpdates()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Internal

        var viewModel: ViewModel
        var spacer = CGFloat.zero
        var defaultPosition = CGPoint.zero
        var initialNodeX: CGFloat = .zero
        var verticalSpacing: CGFloat = .zero

        func reset() {
            backgroundColor = .clear
            removeAllChildren()
            removeAllActions()

            self.dropDestinations = []

            self.setFirstAnswerPosition()
            self.layoutAnswers()
        }

        func exerciseCompletedBehavior() {
            for node in self.dropDestinations {
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
            for (index, gameplayChoiceModel) in self.viewModel.choices.enumerated() {
                let draggableImageAnswerNode = DraggableImageAnswerNode(
                    choice: gameplayChoiceModel,
                    position: defaultPosition
                )
                let draggableImageShadowNode = DraggableImageShadowNode(
                    draggableImageAnswerNode: draggableImageAnswerNode
                )

                self.normalizeAnswerNodesSize([draggableImageAnswerNode, draggableImageShadowNode])
                self.bindNodesToSafeArea([draggableImageAnswerNode, draggableImageShadowNode])
                self.setNextAnswerPosition(index)

                addChild(draggableImageShadowNode)
                addChild(draggableImageAnswerNode)

                self.dropDestinations.append(draggableImageAnswerNode)
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
            fatalError("setFirstAnswerPosition() has not been implemented")
        }

        func setNextAnswerPosition(_: Int) {
            fatalError("setNextAnswerPosition(_ index:) has not been implemented")
        }

        func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
            node.scaleForMax(sizeOf: self.biggerSide * 0.8)
            node.zPosition = (self.playedDestination?.zPosition ?? 10) + 10
            node.isDraggable = false
            self.playedDestination?.isDraggable = false
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

        override func didMove(to _: SKView) {
            self.reset()
        }

        // overriden Touches states
        override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if let node = atPoint(location) as? DraggableImageAnswerNode {
                    for choice in self.viewModel
                        .choices where node.id == choice.id && node.isDraggable
                    {
                        selectedNodes[touch] = node
                        onDragAnimation(node)
                        node.zPosition += 100
                    }
                }
            }
        }

        override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if let node = selectedNodes[touch] {
                    let bounds: CGRect = view!.bounds
                    if node.fullyContains(location: location, bounds: bounds) {
                        node.position = location
                    } else {
                        self.wrongAnswerBehavior(node)
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

                guard let destinationNode = dropDestinations.first(where: {
                    $0.frame.contains(touch.location(in: self)) && $0.id != playedNode!.id
                })
                else {
                    self.wrongAnswerBehavior(self.playedNode!)
                    break
                }
                self.playedDestination = destinationNode

                guard let destination = viewModel.choices.first(where: { $0.id == destinationNode.id })
                else { return }
                guard let choice = viewModel.choices.first(where: { $0.id == playedNode!.id })
                else { return }

                self.viewModel.onChoiceDropped(choice: choice, destination: destination)
            }
        }

        // MARK: Private

        private var biggerSide: CGFloat = 150
        private var playedNode: DraggableImageAnswerNode?
        private var playedDestination: DraggableImageAnswerNode?
        private var dropDestinations: [DraggableImageAnswerNode] = []
        private var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
        private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
        private var cancellables: Set<AnyCancellable> = []
    }
}
