// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import UtilsKit

extension DNDView {
    class DNDBaseScene: SKScene {
        // MARK: Lifecycle

        init(viewModel: DNDView.ViewModel) {
            self.viewModel = viewModel
            super.init(size: CGSize.zero)
            self.subscribeToChoicesUpdates()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Internal

        var viewModel: DNDView.ViewModel
        var spacer: CGFloat = .zero
        var defaultPosition: CGPoint = .zero
        var initialNodeX: CGFloat = .zero
        var verticalSpacing: CGFloat = .zero

        override func didMove(to view: SKView) {
            super.didMove(to: view)
            self.reset()
        }

        // MARK: - Node Layout and Reset

        func reset() {
            backgroundColor = .clear
            removeAllChildren()
            removeAllActions()
            self.dropDestinations.removeAll()
            self.setFirstAnswerPosition()
            self.layoutChoices()
        }

        func layoutChoices() {
            for (index, choice) in self.viewModel.choices.enumerated() {
                let draggableNode = DNDAnswerNode(choice: choice, position: defaultPosition)
                addChild(draggableNode)
                self.dropDestinations.append(draggableNode)
                self.setNextAnswerPosition(index)
            }
        }

        // MARK: - Answer Positioning

        func setFirstAnswerPosition() {
            fatalError("setFirstAnswerPosition() must be implemented in the sub-scene")
        }

        func setNextAnswerPosition(_: Int) {
            fatalError("setNextAnswerPosition(_ index:) must be implemented in the sub-scene")
        }

        // MARK: - Animations

        func onDragAnimation(_ node: SKSpriteNode) {
            let wiggleAnimation = SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
                SKAction.rotate(byAngle: 0.0, duration: 0.1),
                SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
            ])
            node.run(SKAction.repeatForever(wiggleAnimation))
        }

        func onDropAction(_ node: SKSpriteNode) {
            node.zRotation = 0
            node.removeAllActions()
            self.selectedNodes.removeAll()
        }

        func wrongAnswerBehavior(_ node: DNDAnswerNode) {
            let moveAnimation = SKAction.move(to: node.defaultPosition ?? .zero, duration: 0.25)
            let group = DispatchGroup()
            group.enter()
            node.run(
                moveAnimation,
                completion: {
                    node.position = node.defaultPosition ?? .zero
                    node.zPosition = 10
                    group.leave()
                }
            )
            group.notify(queue: .main) {
                self.onDropAction(node)
                self.reset()
            }
        }

        func goodAnswerBehavior(_ node: DNDAnswerNode) {
            node.zPosition = (self.playedDestination?.zPosition ?? 10) + 10
            node.isDraggable = false
            node.scale(to: CGSize(width: 75, height: 75))
            self.playedDestination?.isDraggable = false
            self.onDropAction(node)
        }

        // MARK: - Subscription and Updates

        func subscribeToChoicesUpdates() {
            self.viewModel.$choices
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] choices in
                    guard let self else { return }
                    for choice in choices {
                        if let node = self.dropDestinations.first(where: { $0.id == choice.id }) {
                            node.choiceModel = choice
                            node.updateColorByState()
                        }
                    }
                    for choice in choices where choice.id == self.playedNode?.id {
                        if choice.state == .correct() {
                            self.goodAnswerBehavior(self.playedNode!)
                        } else if choice.state == .idle {
                            self.wrongAnswerBehavior(self.playedNode!)
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        // MARK: - Touch Interaction

        override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if let node = atPoint(location) as? DNDAnswerNode {
                    for choice in self.viewModel.choices where node.id == choice.id && node.isDraggable {
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
                    node.position = location
                }
            }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
            for touch in touches {
                guard self.selectedNodes.keys.contains(touch) else {
                    break
                }
                self.playedNode = self.selectedNodes[touch]!

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

        private var selectedNodes: [UITouch: DNDAnswerNode] = [:]
        private var dropDestinations: [DNDAnswerNode] = []

        private var playedNode: DNDAnswerNode?
        private var playedDestination: DNDAnswerNode?
        private var cancellables: Set<AnyCancellable> = []
    }
}
