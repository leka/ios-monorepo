// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

class DnDOneToOneBaseScene: SKScene {
    // MARK: Lifecycle

    init(viewModel: DnDOneToOneViewModel) {
        self.viewModel = viewModel
        super.init(size: CGSize.zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func didMove(to _: SKView) {
        self.reset()
    }

    // MARK: - Touch Interaction

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if let node = atPoint(location) as? DnDAnswerNode {
            for choice in self.viewModel.choices where node.id == choice.id && node.isDraggable {
                selectedNodes[touch] = node
                self.viewModel.onTouch(.began, choice: node)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if let node = selectedNodes[touch] {
            node.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard let touch = touches.first,
              let playedNode = self.selectedNodes[touch]
        else {
            return
        }

        self.viewModel.onTouch(.ended, choice: playedNode, destination: self.dropZonesNodes.first(where: {
            $0.frame.contains(touch.location(in: self))
        }))
    }

    func reset() {
        backgroundColor = .clear
        removeAllChildren()
        removeAllActions()

        self.setFirstAnswerPosition()
        self.layoutChoices()
        self.layoutDropzones()
        self.viewModel.setAlreadyOrderedNodes()
    }

    func exerciseCompletedBehavior() {
        for node in self.answerNodes {
            node.isDraggable = false
        }
    }

    func layoutChoices() {
        for (index, choice) in self.viewModel.choices.enumerated() {
            choice.initialPosition = self.setInitialPosition(index)
            choice.position = choice.initialPosition!

            let shadowChoice = DnDShadowNode(node: choice)

            self.bindNodesToSafeArea([choice, shadowChoice])
            self.answerNodes.append(choice)

            addChild(shadowChoice)
            addChild(choice)
        }
    }

    func layoutDropzones() {
        for (index, dropzone) in self.viewModel.dropzones.enumerated() {
            dropzone.position = self.setInitialDropZonePosition(index)

            self.bindNodesToSafeArea([dropzone])
            self.dropZonesNodes.append(dropzone)

            addChild(dropzone)
        }
    }

    func bindNodesToSafeArea(_ nodes: [SKSpriteNode], limit: CGFloat = 80) {
        let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - limit)
        let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - limit)
        for node in nodes {
            node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        }
    }

    func normalizeNodesSize(_ nodes: [SKSpriteNode]) {
        for node in nodes {
            node.scaleForMax(sizeOf: self.maxWidthAndHeight)
        }
    }

    func setFirstAnswerPosition() {
        self.spacer = size.width / CGFloat(self.viewModel.choices.count + 1)
        self.maxWidthAndHeight = 200 - 5 * CGFloat(self.viewModel.choices.count)
    }

    func setInitialPosition(_ index: Int) -> CGPoint {
        CGPoint(x: self.spacer * CGFloat(index + 1), y: size.height - 120)
    }

    func setInitialDropZonePosition(_ index: Int) -> CGPoint {
        CGPoint(x: self.spacer * CGFloat(index + 1), y: 120)
    }

    // MARK: Private

    private var spacer: CGFloat = .zero
    private var maxWidthAndHeight: CGFloat = .zero
    private var viewModel: DnDOneToOneViewModel
    private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    private var selectedNodes: [UITouch: DnDAnswerNode] = [:]
    private var dropZonesNodes: [DnDDropZoneNode] = []
    private var answerNodes: [DnDAnswerNode] = []
    private var playedNode: DnDAnswerNode?
}
