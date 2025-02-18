// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit

class DnDGridBaseScene: SKScene {
    // MARK: Lifecycle

    init(viewModel: DnDGridViewModel) {
        self.viewModel = viewModel
        super.init(size: CGSize.zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var viewModel: DnDGridViewModel
    var initialNodeX: CGFloat = .zero
    var horizontalSpacer: CGFloat = .zero
    var verticalSpacer: CGFloat = .zero

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .clear
        removeAllChildren()
        removeAllActions()
        self.setPositionVariables()
        self.layoutChoices()
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

        self.viewModel.onTouch(
            .ended,
            choiceID: playedNode.id,
            destinationID: self.dropDestinations.first(where: {
                $0.frame.contains(touch.location(in: self)) && $0.id != playedNode.id
            })?.id
        )
    }

    // MARK: - Node Layout

    func layoutChoices() {
        for (index, choice) in self.viewModel.choices.enumerated() {
            choice.initialPosition = self.setChoicePosition(index)
            choice.position = choice.initialPosition!
            self.bindNodesToSafeArea([choice])
            self.dropDestinations.append(choice)

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

    // MARK: - Answer Positioning

    func setPositionVariables() {
        fatalError("setPositionVariables() must be implemented in the sub-scene")
    }

    func setChoicePosition(_: Int) -> CGPoint {
        fatalError("setNextAnswerPosition(_ index:) must be implemented in the sub-scene")
    }

    // MARK: Private

    private var selectedNodes: [UITouch: DnDAnswerNode] = [:]
    private var dropDestinations: [DnDAnswerNode] = []
    private var cancellables: Set<AnyCancellable> = []
}
