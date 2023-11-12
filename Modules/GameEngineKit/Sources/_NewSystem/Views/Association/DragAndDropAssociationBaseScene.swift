// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

// TODO(@macteuts): adapt this to Association Layout
class DragAndDropAssociationBaseScene: SKScene {
    var viewModel: DragAndDropAssociationViewViewModel
    private var biggerSide: CGFloat = 150
    private var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
    private var playedNode: DraggableImageAnswerNode?
    private var answerNodes: [DraggableImageAnswerNode] = []
    private var spacer: CGFloat = 455
    private var defaultPosition = CGPoint.zero
    private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    private var dropDestinations: [DraggableImageAnswerNode] = []
    private var dropDestinationAnchor: CGPoint = .zero
    private var initialNodeX: CGFloat = .zero
    private var verticalSpacing: CGFloat = .zero
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: DragAndDropAssociationViewViewModel) {
        self.viewModel = viewModel
        super.init(size: CGSize.zero)
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

        dropDestinations = []

        setFirstAnswerPosition()
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
            .sink(receiveValue: {
                for gameplayChoiceModel in $0 where gameplayChoiceModel.choice.value == self.playedNode?.name {
                    if gameplayChoiceModel.state == .rightAnswer {
                        self.goodAnswerBehavior(self.playedNode!)
                    } else if gameplayChoiceModel.state == .wrongAnswer {
                        self.wrongAnswerBehavior(self.playedNode!)
                    }
                }
            })
            .store(in: &cancellables)
    }

    @MainActor func layoutAnswers() {
        for (index, gameplayChoiceModel) in viewModel.choices.enumerated() {
            let draggableImageAnswerNode = DraggableImageAnswerNode(
                choice: gameplayChoiceModel.choice,
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
                for gameplayChoiceModel in viewModel.choices
                where node.name == gameplayChoiceModel.choice.value && node.isDraggable {
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

            // make dropArea out of target node
            guard
                let destinationNode = dropDestinations.first(where: {
                    $0.frame.contains(touch.location(in: self)) && $0.name != playedNode!.name
                })
            else {
                wrongAnswerBehavior(playedNode!)
                break
            }

            guard let destination = viewModel.choices.first(where: { $0.choice.value == destinationNode.name })
            else { return }
            guard let choice = viewModel.choices.first(where: { $0.choice.value == playedNode!.name })
            else { return }

            guard choice.choice.category == destination.choice.category else {
                wrongAnswerBehavior(playedNode!)
                break
            }
            // dropped within the bounds of the proper sibling
            destinationNode.isDraggable = false
            viewModel.onChoiceTapped(choice: choice)
            // viewModel.onChoiceTapped(choice: destination)
        }
    }
}
