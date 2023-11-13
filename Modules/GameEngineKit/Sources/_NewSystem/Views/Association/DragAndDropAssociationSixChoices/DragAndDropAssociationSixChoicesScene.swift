// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

final class DragAndDropAssociationSixChoicesScene: DragAndDropAssociationBaseScene {

    private var freeSlots: [String: [Bool]] = [:]
    private var endAbscissa: CGFloat = .zero
    private var finalXPosition: CGFloat = .zero

    override init(viewModel: DragAndDropAssociationViewViewModel) {
        super.init(viewModel: viewModel)
        self.viewModel = viewModel

        subscribeToChoicesUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reset() {
        self.backgroundColor = .clear
        self.removeAllChildren()
        self.removeAllActions()

        dropDestinations = []

        setAnswersFinalPositionSlots()
        setFirstAnswerPosition()
        layoutAnswers()
    }

    private func setAnswersFinalPositionSlots() {
        freeSlots = [:]
        for gameplayChoiceModel in viewModel.choices {
            let category = gameplayChoiceModel.choice.category.rawValue
            freeSlots[category] = [true, true]
        }
    }

    override func setFirstAnswerPosition() {
        spacer = 340
        initialNodeX = (size.width - (spacer * 2)) / 2
        verticalSpacing = self.size.height / 3
        defaultPosition = CGPoint(x: initialNodeX, y: verticalSpacing - 30)
    }

    override func setNextAnswerPosition(_ index: Int) {
        if [0, 1, 3, 4].contains(index) {
            defaultPosition.x += spacer
        } else {
            defaultPosition.x = initialNodeX
            defaultPosition.y += verticalSpacing + 60
        }
    }

    private func setFinalXPosition(category: String) {
        guard endAbscissa <= dropDestinationAnchor.x else {
            finalXPosition = {
                guard freeSlots[category]![1] else {
                    freeSlots[category]![0] = false
                    return dropDestinationAnchor.x - 80
                }
                freeSlots[category]![1] = false
                return dropDestinationAnchor.x + 80
            }()
            return
        }
        finalXPosition = {
            guard freeSlots[category]![0] else {
                freeSlots[category]![1] = false
                return dropDestinationAnchor.x + 80
            }
            freeSlots[category]![0] = false
            return dropDestinationAnchor.x - 80
        }()
    }

    override func goodAnswerBehavior(_ node: DraggableImageAnswerNode) {
        node.scaleForMax(sizeOf: biggerSide * 0.8)
        node.position = CGPoint(
            x: finalXPosition,
            y: dropDestinationAnchor.y - 60)
        node.zPosition = 10
        node.isDraggable = false
        playedDestination?.isDraggable = false
        onDropAction(node)
        if viewModel.exercicesSharedData.state == .completed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                exerciseCompletedBehavior()
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
            endAbscissa = touch.location(in: self).x

            guard
                let destinationNode = dropDestinations.first(where: {
                    $0.frame.contains(touch.location(in: self)) && $0.name != playedNode!.name
                })
            else {
                wrongAnswerBehavior(playedNode!)
                break
            }
            dropDestinationAnchor = destinationNode.position
            playedDestination = destinationNode

            guard let destination = viewModel.choices.first(where: { $0.choice.value == destinationNode.name })
            else { return }
            guard let choice = viewModel.choices.first(where: { $0.choice.value == playedNode!.name })
            else { return }

            // dropped within the bounds of the proper sibling
            setFinalXPosition(category: destination.choice.category.rawValue)
            viewModel.onChoiceTapped(choice: choice, destination: destination)
        }
    }
}
