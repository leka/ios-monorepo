// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

class DnDGridWithZonesBaseScene: SKScene {
    // MARK: Lifecycle

    init(viewModel: DnDGridWithZonesViewModel) {
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
                self.viewModel.onTouch(.began, choiceID: node.id)
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

        self.viewModel.onTouch(.ended, choiceID: playedNode.id, destinationID: self.dropZonesNodes.first(where: {
            $0.frame.contains(touch.location(in: self))
        })?.id)
    }

    func reset() {
        backgroundColor = .clear
        removeAllChildren()
        removeAllActions()

        self.setPositionVariables()
        self.layoutDropZones()
        self.layoutAnswers()
    }

    func exerciseCompletedBehavior() {
        for node in self.answerNodes {
            node.isDraggable = false
        }
    }

    func layoutAnswers() {
        for (index, choice) in self.viewModel.choices.enumerated() {
            choice.initialPosition = self.setChoicePosition(index)
            choice.position = choice.initialPosition!

            let shadowChoice = DnDShadowNode(node: choice)
            self.bindNodesToSafeArea([choice, shadowChoice])
            self.answerNodes.append(choice)
            addChild(shadowChoice)
            addChild(choice)
        }
    }

    func bindNodesToSafeArea(_ nodes: [SKSpriteNode], limit: CGFloat = 80) {
        let xRange = SKRange(lowerLimit: 0, upperLimit: size.width - limit)
        let yRange = SKRange(lowerLimit: 0, upperLimit: size.height - limit)
        for node in nodes {
            node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        }
    }

    func setPositionVariables() {
        self.spacer = size.width / CGFloat(self.viewModel.choices.count + 1)
    }

    func setChoicePosition(_ index: Int) -> CGPoint {
        CGPoint(x: self.spacer * CGFloat(index + 1), y: 4 * size.height / 5)
    }

    func layoutDropZones() {
        for (index, dropzone) in self.viewModel.dropzones.enumerated() {
            let dropzonesNumber = self.viewModel.dropzones.count
            let posX = CGFloat(2 * index + 1) * size.width / CGFloat(2 * dropzonesNumber)

            dropzone.position = CGPoint(x: posX, y: size.height / 3)

            addChild(dropzone)
            self.dropZonesNodes.append(dropzone)
        }
    }

    // MARK: Private

    private var viewModel: DnDGridWithZonesViewModel
    private var selectedNodes: [UITouch: DnDAnswerNode] = [:]
    private var dropZonesNodes: [DnDDropZoneNode] = []
    private var answerNodes: [DnDAnswerNode] = []
    private var playedNode: DnDAnswerNode?
    private var spacer: CGFloat = .zero
}
