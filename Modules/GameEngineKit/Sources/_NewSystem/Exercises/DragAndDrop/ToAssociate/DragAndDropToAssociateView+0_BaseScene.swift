// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

extension DragAndDropToAssociateView {
    class BaseScene: SKScene {
        var viewModel: ViewModel
        var spacer = CGFloat.zero
        var defaultPosition = CGPoint.zero
        var initialNodeX: CGFloat = .zero
        var verticalSpacing: CGFloat = .zero

        private var biggerSide: CGFloat = 150
        private var playedNode: DraggableImageAnswerNode?
        private var playedDestination: DraggableImageAnswerNode?
        private var dropDestinations: [DraggableImageAnswerNode] = []
        private var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
        private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
        private var cancellables: Set<AnyCancellable> = []

        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            super.init(size: CGSize.zero)

            subscribeToChoicesUpdates()
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
            layoutAnswers()
        }

        func exerciseCompletedBehavior() {
            for node in dropDestinations {
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
            for (index, gameplayChoiceModel) in viewModel.choices.enumerated() {
                let draggableImageAnswerNode = DraggableImageAnswerNode(
                    choice: gameplayChoiceModel,
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

        func setNextAnswerPosition(_ index: Int) {
            fatalError("setNextAnswerPosition(_ index:) has not been implemented")
        }

        func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
            node.scaleForMax(sizeOf: biggerSide * 0.8)
            node.zPosition = (self.playedDestination?.zPosition ?? 10) + 10
            node.isDraggable = false
            playedDestination?.isDraggable = false
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

        override func didMove(to view: SKView) {
            self.reset()
        }

        // overriden Touches states
        override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if let node = self.atPoint(location) as? DraggableImageAnswerNode {
                    for choice in viewModel
                        .choices where node.id == choice.id && node.isDraggable
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
                    let bounds: CGRect = self.view!.bounds
                    if node.fullyContains(location: location, bounds: bounds) {
                        node.run(SKAction.move(to: location, duration: 0.05).moveAnimation(.linear))
                        node.position = location
                    } else {
                        wrongAnswerBehavior(node)
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

                guard
                    let destinationNode = dropDestinations.first(where: {
                        $0.frame.contains(touch.location(in: self)) && $0.id != playedNode!.id
                    })
                else {
                    wrongAnswerBehavior(playedNode!)
                    break
                }
                playedDestination = destinationNode

                guard let destination = viewModel.choices.first(where: { $0.id == destinationNode.id })
                else { return }
                guard let choice = viewModel.choices.first(where: { $0.id == playedNode!.id })
                else { return }

                viewModel.onChoiceTapped(choice: choice, destination: destination)
            }
        }
    }
}
