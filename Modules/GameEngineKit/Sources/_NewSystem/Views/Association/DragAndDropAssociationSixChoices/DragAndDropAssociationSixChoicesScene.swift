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
        self.spacer = 340
        self.defaultPosition = CGPoint(x: spacer, y: self.size.height)

        subscribeToChoicesUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setFirstAnswerPosition() {
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

    private func setFinalXPosition(context: String) {
        guard endAbscissa <= dropDestinationAnchor.x else {
            finalXPosition = {
                guard freeSlots[context]![1] else {
                    freeSlots[context]![0] = false
                    return dropDestinationAnchor.x - 80
                }
                freeSlots[context]![1] = false
                return dropDestinationAnchor.x + 80
            }()
            return
        }
        finalXPosition = {
            guard freeSlots[context]![0] else {
                freeSlots[context]![1] = false
                return dropDestinationAnchor.x + 80
            }
            freeSlots[context]![0] = false
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
        onDropAction(node)
        if viewModel.exercicesSharedData.state == .completed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                exerciseCompletedBehavior()
            }
        }
    }
}
