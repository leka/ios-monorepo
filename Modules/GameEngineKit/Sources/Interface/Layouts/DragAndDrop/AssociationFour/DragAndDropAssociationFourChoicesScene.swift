// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

class DragAndDropAssociationFourChoicesScene: DragAndDropBaseScene {

    public init(viewModel: GenericViewModel) {
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

            ////////
            // make dropArea out of target node
//            let dropAreaIndex = dropDestinations.firstIndex(where: {
//                $0.frame.contains(touch.location(in: self)) && $0.name != playedNode!.name
//            })
//            // dropped outside the bounds of any dropArea
//            guard dropAreaIndex != nil else {
//                wrongAnswerBehavior(playedNode!)
//                break
//            }
//            let dropArea = dropDestinations[dropAreaIndex!]
//            dropDestinationAnchor = dropArea.position
//            // define contexts
//            var rightContext = String()
//            var wrongContext = String()
//            for context in expectedItemsNodes {
//                for item in context.value where item.name == playedNode!.name {
//                    rightContext = context.key
//                }
//            }
//            for context in expectedItemsNodes where context.key != rightContext {
//                wrongContext = context.key
//            }
//            let index = viewModel.choices.firstIndex(where: { $0.item == playedNode!.name })
//            let destinationIndex = viewModel.choices.firstIndex(where: { $0.item == dropArea.name })
//
//            //            guard (gameEngine?.correctAnswersIndices[rightContext, default: []].contains(destinationIndex!))!
//            guard playedNode!.fullyContains(bounds: dropArea.frame)
//            else {
//                // dropped within the bounds of the wrong sibling
//                //                gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: wrongContext)
//                wrongAnswerBehavior(playedNode!)
//                break
//            }
//            // dropped within the bounds of the proper sibling
//            dropDestinations[dropAreaIndex!].isDraggable = false
//            //            gameEngine?.answerHasBeenGiven(atIndex: index!, withinContext: rightContext)
//            //            gameEngine?.answerHasBeenGiven(atIndex: destinationIndex!, withinContext: rightContext)
//            let choice = viewModel.choices.first(where: { $0.item == playedNode!.name })
//            viewModel.onChoiceTapped(choice: choice!)
            ////////

            // from working other
//            let choice = viewModel.choices.first(where: { $0.item == playedNode!.name })
//            if playedNode!.fullyContains(bounds: dropAreasNode[0].frame) {
//                viewModel.onChoiceTapped(choice: choice!)
//                break
//            }
//            wrongAnswerBehavior(playedNode!)
        }
    }
}
