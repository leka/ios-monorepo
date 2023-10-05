// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

class DragAndDropOneAreaOneChoiceScene: SKScene, DragAndDropSceneProtocol {

    // protocol requirements
    var viewModel: GenericViewModel?
    var contexts: [ContextViewModel]?
    var spacer: CGFloat = .zero
    var defaultPosition = CGPoint.zero
    var selectedNodes: [UITouch: DraggableImageAnswerNode] = [:]
    var expectedItemsNodes: [String: [SKSpriteNode]] = [:]
    var dropAreas: [SKSpriteNode] = []

    private var playedNode: DraggableImageAnswerNode?

    public init(contexts: [ContextViewModel]) {
        self.contexts = contexts
        super.init(size: CGSize.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // protocol methods
    func layoutFirstAnswer() {
        spacer = size.width / 2
        defaultPosition = CGPoint(x: spacer, y: self.size.height)
    }

    // MARK: - SKScene specifics
    // init
    override func didMove(to view: SKView) {
        self.reset()
    }

    override func update(_ currentTime: TimeInterval) {
        guard let vModel = viewModel else {
            return
        }
        for choice in vModel.choices where choice.item == playedNode?.name {
            if choice.status == .playingRightAnimation {
                dropGoodAnswer(playedNode!)
            } else if choice.status == .playingWrongAnimation {
                snapBack(playedNode!)
            }
        }
    }

    // overriden Touches states
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? DraggableImageAnswerNode {
                for choice in viewModel!.choices where node.name == choice.item && node.isDraggable {
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
            if !selectedNodes.keys.contains(touch) {
                break
            }
            playedNode = selectedNodes[touch]!
            playedNode!.scaleForMax(sizeOf: biggerSide)
            let choice = viewModel!.choices.first(where: { $0.item == playedNode!.name })
            // dropped within the bounds of dropArea
            if playedNode!.fullyContains(bounds: dropAreas[0].frame) {
                viewModel!.onChoiceTapped(choice: choice!)
                break
            }

            // dropped outside the bounds of dropArea
            snapBack(playedNode!)
        }
    }
}
