// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

class DragAndDropBaseSceneDeprecated: SKScene {
    var viewModel: DragAndDropZoneViewModel
    var hints: Bool
    var biggerSide: CGFloat = 130
    var selectedNodes: [UITouch: DraggableImageAnswerNodeDeprecated] = [:]
    var playedNode: DraggableImageAnswerNodeDeprecated?
    var dropZonesNode: [SKSpriteNode] = []
    private var spacer: CGFloat = .zero
    private var defaultPosition = CGPoint.zero
    private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: DragAndDropZoneViewModel, hints: Bool) {
        self.viewModel = viewModel
        self.hints = hints
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
        layoutDropZones(dropZones: viewModel.dropZones)
        getExpectedItems()
        layoutAnswers()
    }

    func subscribeToChoicesUpdates() {
        self.viewModel.$dropZones
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                for dropZone in $0 {
                    for choice in dropZone.choices where choice.value == self.playedNode?.name {
                        if choice.status == .rightAnswer {
                            self.goodAnswerBehavior(self.playedNode!)
                        } else if choice.status == .wrongAnswer {
                            self.wrongAnswerBehavior(self.playedNode!)
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }

    @MainActor func layoutAnswers() {
        for choice in viewModel.choices {
            let draggableImageAnswerNode = DraggableImageAnswerNodeDeprecated(
                choice: choice,
                position: self.defaultPosition
            )
            let draggableImageShadowNode = DraggableImageShadowNodeDeprecated(
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

    func layoutDropZones(dropZones: [DragAndDropZoneModel]) {
        // To specify in final classes
    }

    func getExpectedItems() {
        for dropZone in viewModel.dropZones {
            for choice in dropZone.choices {
                let expectedItem = choice.value
                let expectedNode = SKSpriteNode()

                guard hints else {
                    expectedNode.name = expectedItem
                    (expectedItemsNodes[dropZone.value, default: []]).append(expectedNode)
                    return
                }
                let texture = SKTexture(imageNamed: expectedItem)
                let action = SKAction.setTexture(texture, resize: true)
                expectedNode.run(action)
                expectedNode.name = expectedItem
                expectedNode.texture = texture
                expectedNode.scaleForMax(sizeOf: biggerSide * 0.8)
                expectedNode.position = CGPoint(x: dropZonesNode[0].position.x + 80, y: 110)
                (expectedItemsNodes[dropZone.value, default: []]).append(expectedNode)

                addChild(expectedNode)
            }
        }
    }

    func goodAnswerBehavior(_ node: DraggableImageAnswerNodeDeprecated) {
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

    func wrongAnswerBehavior(_ node: DraggableImageAnswerNodeDeprecated) {
        let moveAnimation: SKAction = SKAction.move(to: node.defaultPosition!, duration: 0.25)
            .moveAnimationDeprecated(.easeOut)
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
            SKAction.rotate(byAngle: CGFloat(degreesToRadianDeprecated(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadianDeprecated(degrees: 4)), duration: 0.1),
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
            if let node = self.atPoint(location) as? DraggableImageAnswerNodeDeprecated {
                for choice in viewModel.choices where node.name == choice.value && node.isDraggable {
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
                if node.fullyContainsDeprecated(location: location, bounds: bounds) {
                    node.run(SKAction.move(to: location, duration: 0.05).moveAnimationDeprecated(.linear))
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
            let choice = viewModel.choices.first(where: { $0.value == playedNode!.name })
            for dropZoneNode in dropZonesNode where playedNode!.fullyContainsDeprecated(bounds: dropZoneNode.frame) {
                viewModel.onChoiceTapped(choice: choice!, dropZoneName: dropZoneNode.name!)
                break
            }

            wrongAnswerBehavior(playedNode!)
        }
    }
}
