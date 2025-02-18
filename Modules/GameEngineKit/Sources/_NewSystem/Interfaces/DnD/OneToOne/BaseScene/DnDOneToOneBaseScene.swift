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

        self.spacer = size.width / CGFloat(self.viewModel.choices.count + 1)

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
            choice.initialPosition = self.setChoicePosition(index)
            choice.position = choice.initialPosition!
            self.answerNodes.append(choice)

            let shadowChoice = DnDShadowNode(node: choice)
            addChild(shadowChoice)
            addChild(choice)
        }
    }

    func layoutDropzones() {
        for (index, dropzone) in self.viewModel.dropzones.enumerated() {
            dropzone.position = self.setDropZonePosition(index)
            self.dropZonesNodes.append(dropzone)
            addChild(dropzone)
        }
    }

    func setChoicePosition(_ index: Int) -> CGPoint {
        CGPoint(x: self.spacer * CGFloat(index + 1), y: size.height - self.viewModel.choices[0].size.height * 0.8)
    }

    func setDropZonePosition(_ index: Int) -> CGPoint {
        CGPoint(x: self.spacer * CGFloat(index + 1), y: self.viewModel.choices[0].size.height * 0.8)
    }

    // MARK: Private

    private var spacer: CGFloat = .zero
    private var viewModel: DnDOneToOneViewModel
    private var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    private var selectedNodes: [UITouch: DnDAnswerNode] = [:]
    private var dropZonesNodes: [DnDDropZoneNode] = []
    private var answerNodes: [DnDAnswerNode] = []
    private var playedNode: DnDAnswerNode?
}
