// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

class DragAndDropAssociationFourChoicesScene: DragAndDropAssociationScene {

    public override init(viewModel: GenericViewModel) {
        super.init(viewModel: viewModel)

        subscribeToChoicesUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SKScene specifics
    override func didMove(to view: SKView) {
        self.reset()
    }

    // overriden Touches states
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? DraggableImageAnswerNode {
                for choice in viewModel.choices where node.name == choice.item && node.isDraggable {
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

            guard
                let destination = viewModel.choices.first(where: { $0.item == destinationNode.name }) as? CategoryModel
            else { return }
            guard let choice = viewModel.choices.first(where: { $0.item == playedNode!.name }) as? CategoryModel
            else { return }
            
            guard choice.category == destination.category else {
                wrongAnswerBehavior(playedNode!)
                break
            }
            // dropped within the bounds of the proper sibling
            destinationNode.isDraggable = false
            dropDestinationAnchor = destinationNode.position
            viewModel.onChoiceTapped(choice: destination)
            viewModel.onChoiceTapped(choice: choice)
        }
    }
}
