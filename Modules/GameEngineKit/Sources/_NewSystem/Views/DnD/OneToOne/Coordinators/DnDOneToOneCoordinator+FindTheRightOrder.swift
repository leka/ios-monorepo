// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDOneToOneCoordinatorFindTheRightOrder

public class DnDOneToOneCoordinatorFindTheRightOrder: DnDOneToOneGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightOrderChoiceModel], action: Exercise.Action? = nil) {
        self.rawChoices = choices

        self.gameplay = NewGameplayFindTheRightOrder(choices: choices.map { .init(id: $0.id) })

        self.uiModel.value.action = action
        self.uiModel.value.choices = choices.map { choice in
            DnDAnswerNode(
                id: choice.id,
                value: choice.value,
                type: choice.type,
                size: self.uiModel.value.choiceSize(for: choices.count)
            )
        }

        self.uiDropZones = self.uiModel.value.choices.map { node in
            DnDDropZoneNode(node: node)
        }

        self.uiModel.value.choices.shuffle()

        self.currentOrderedChoices = Array(repeating: nil, count: self.gameplay.orderedChoices.count)
        self.alreadyValidatedChoices = Array(repeating: nil, count: self.gameplay.orderedChoices.count)
    }

    // MARK: Public

    public private(set) var uiDropZones: [DnDDropZoneNode] = []
    public private(set) var uiModel = CurrentValueSubject<DnDOneToOneUIModel, Never>(.zero)

    public func setAlreadyOrderedNodes() {
        self.rawChoices.forEach { choice in
            if choice.alreadyOrdered {
                guard let index = self.uiDropZones.firstIndex(where: { $0.id == choice.id }) else { return }
                self.updateChoiceState(for: choice.id, to: .correct(order: index))
                self.currentOrderedChoices[index] = choice.id
                self.alreadyValidatedChoices[index] = choice.id
            }
        }
    }

    public func onTouch(_ event: DnDTouchEvent, choiceID: UUID, destinationID: UUID? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: choiceID, to: .dragged)
            case .ended:
                guard let destinationID else {
                    self.updateChoiceState(for: choiceID, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choiceID: choiceID, destinationID: destinationID)
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayFindTheRightOrder

    private let rawChoices: [CoordinatorFindTheRightOrderChoiceModel]
    private var currentOrderedChoices: [UUID?] = []
    private var alreadyValidatedChoices: [UUID?] = []

    private func processUserDropOnDestination(choiceID: UUID, destinationID: UUID) {
        guard let choiceID = self.rawChoices.first(where: { $0.id == choiceID })?.id,
              let destinationIndex = self.uiDropZones.firstIndex(where: { $0.id == destinationID }),
              !self.choiceAlreadySelected(choiceID: choiceID) else { return }

        self.order(choiceID: choiceID, dropZoneIndex: destinationIndex)
        if self.currentOrderedChoices.doesNotContain(nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let results = self.gameplay.process(choiceIDs: self.currentOrderedChoices.map { $0! })

                results.enumerated().forEach { index, result in
                    let choiceID = self.rawChoices.first(where: { $0.id == result.id })!.id
                    if result.correctPosition {
                        self.updateChoiceState(for: choiceID, to: .correct(order: index))
                        self.alreadyValidatedChoices[index] = choiceID
                    } else {
                        self.updateChoiceState(for: choiceID, to: .idle)
                        self.currentOrderedChoices[index] = nil
                    }
                }
            }
        }
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choiceID }) else { return }

        self.updateUINodeState(node: self.uiModel.value.choices[index], state: state)
    }

    private func choiceAlreadySelected(choiceID: UUID) -> Bool {
        self.alreadyValidatedChoices.contains(where: { $0 == choiceID })
    }

    private func order(choiceID: UUID, dropZoneIndex: Int) {
        let previousChoiceID = self.currentOrderedChoices[dropZoneIndex]
        if let index = self.currentOrderedChoices.firstIndex(where: { $0 == choiceID }) {
            if previousChoiceID == nil {
                self.currentOrderedChoices[index] = nil
                self.currentOrderedChoices[dropZoneIndex] = choiceID
                self.updateChoiceState(for: choiceID, to: .ordered(order: dropZoneIndex))
            } else if let previousChoiceID, self.isMovable(choiceID: previousChoiceID) {
                self.currentOrderedChoices[index] = previousChoiceID
                self.currentOrderedChoices[dropZoneIndex] = choiceID
                self.updateChoiceState(for: previousChoiceID, to: .ordered(order: index))
                self.updateChoiceState(for: choiceID, to: .ordered(order: dropZoneIndex))
            } else {
                self.currentOrderedChoices[index] = nil
                self.updateChoiceState(for: choiceID, to: .idle)
            }
        } else {
            if previousChoiceID == nil {
                self.currentOrderedChoices[dropZoneIndex] = choiceID
                self.updateChoiceState(for: choiceID, to: .ordered(order: dropZoneIndex))
            } else if let previousChoiceID, self.isMovable(choiceID: previousChoiceID) {
                self.currentOrderedChoices[dropZoneIndex] = choiceID
                self.updateChoiceState(for: previousChoiceID, to: .idle)
                self.updateChoiceState(for: choiceID, to: .ordered(order: dropZoneIndex))
            } else {
                self.updateChoiceState(for: choiceID, to: .idle)
            }
        }
    }

    private func isMovable(choiceID: UUID) -> Bool {
        self.uiModel.value.choices.first(where: { choiceID == $0.id })!.isDraggable
    }
}

extension DnDOneToOneCoordinatorFindTheRightOrder {
    enum State: Equatable {
        case idle
        case dragged
        case ordered(order: Int)
        case correct(order: Int)
    }

    private func updateUINodeState(node: DnDAnswerNode, state: State) {
        switch state {
            case .idle:
                self.moveNodeBackToInitialPosition(node)
            case .dragged:
                self.onDragAnimation(node)
            case let .ordered(order):
                node.snapToCenter(dropZone: self.uiDropZones[order])
            case let .correct(order):
                node.snapToCenter(dropZone: self.uiDropZones[order])
                node.isDraggable = false
        }
    }

    // MARK: - Animations

    private func onDragAnimation(_ node: SKSpriteNode) {
        let wiggleAnimation = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
        node.zPosition += 100
        node.run(SKAction.repeatForever(wiggleAnimation))
    }

    // MARK: Private

    private func onDropAction(_ node: SKSpriteNode) {
        node.zRotation = 0
        node.removeAllActions()
    }

    private func moveNodeBackToInitialPosition(_ node: DnDAnswerNode) {
        let moveAnimation = SKAction.move(to: node.initialPosition ?? .zero, duration: 0.25)
        node.run(
            moveAnimation,
            completion: {
                node.position = node.initialPosition ?? .zero
                node.zPosition = 10
                self.onDropAction(node)
            }
        )
    }
}
