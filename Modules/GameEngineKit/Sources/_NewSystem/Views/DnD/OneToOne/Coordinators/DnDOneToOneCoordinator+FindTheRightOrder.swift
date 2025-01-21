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

        self.currentOrderedChoices = Array(repeating: .zero, count: self.gameplay.orderedChoices.count)
        self.alreadyValidatedChoices = Array(repeating: .zero, count: self.gameplay.orderedChoices.count)
    }

    // MARK: Public

    public private(set) var uiDropZones: [DnDDropZoneNode] = []
    public private(set) var uiModel = CurrentValueSubject<DnDOneToOneUIModel, Never>(.zero)

    public func setAlreadyOrderedNodes() {
        self.rawChoices.forEach { choice in
            if choice.alreadyOrdered {
                guard let index = self.uiDropZones.firstIndex(where: { $0.id == choice.id }) else { return }
                self.updateChoiceState(for: choice, to: .correct(order: index))
                self.currentOrderedChoices[index] = choice
                self.alreadyValidatedChoices[index] = choice
            }
        }
    }

    public func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: self.rawChoices.first(where: { $0.id == choice.id })!, to: .dragged)
            case .ended:
                guard let destination else {
                    self.updateChoiceState(for: self.rawChoices.first(where: { $0.id == choice.id })!, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choice: choice, destination: destination)
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayFindTheRightOrder

    private let rawChoices: [CoordinatorFindTheRightOrderChoiceModel]
    private var currentOrderedChoices: [CoordinatorFindTheRightOrderChoiceModel] = []
    private var alreadyValidatedChoices: [CoordinatorFindTheRightOrderChoiceModel] = []

    private func processUserDropOnDestination(choice: DnDAnswerNode, destination: DnDDropZoneNode) {
        guard let sourceChoice = self.rawChoices.first(where: { $0.id == choice.id }),
              let destinationIndex = self.uiDropZones.firstIndex(where: { $0.id == destination.id }),
              !self.choiceAlreadySelected(choice: sourceChoice) else { return }

        self.order(choice: sourceChoice, dropZoneIndex: destinationIndex)
        if self.currentOrderedChoices.doesNotContain(.zero) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let results = self.gameplay.process(choiceIDs: self.currentOrderedChoices.map(\.id))

                results.enumerated().forEach { index, result in
                    let choice = self.rawChoices.first(where: { $0.id == result.id })!
                    if result.correctPosition {
                        self.updateChoiceState(for: choice, to: .correct(order: index))
                        self.alreadyValidatedChoices[index] = choice
                    } else {
                        self.updateChoiceState(for: choice, to: .idle)
                        self.currentOrderedChoices[index] = .zero
                    }
                }
            }
        }
    }

    private func updateChoiceState(for choice: CoordinatorFindTheRightOrderChoiceModel, to state: State) {
        guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        self.updateUINodeState(node: self.uiModel.value.choices[index], state: state)
    }

    private func choiceAlreadySelected(choice: CoordinatorFindTheRightOrderChoiceModel) -> Bool {
        self.alreadyValidatedChoices.contains(where: { $0.id == choice.id })
    }

    private func order(choice: CoordinatorFindTheRightOrderChoiceModel, dropZoneIndex: Int) {
        let previousChoice = self.currentOrderedChoices[dropZoneIndex]
        if let index = self.currentOrderedChoices.firstIndex(where: { $0 == choice }) {
            if previousChoice == .zero {
                self.currentOrderedChoices[index] = .zero
                self.currentOrderedChoices[dropZoneIndex] = choice
                self.updateChoiceState(for: choice, to: .ordered(order: dropZoneIndex))
            } else if self.isMovable(choice: previousChoice) {
                self.currentOrderedChoices[index] = previousChoice
                self.currentOrderedChoices[dropZoneIndex] = choice
                self.updateChoiceState(for: previousChoice, to: .ordered(order: index))
                self.updateChoiceState(for: choice, to: .ordered(order: dropZoneIndex))
            } else {
                self.currentOrderedChoices[index] = .zero
                self.updateChoiceState(for: choice, to: .idle)
            }
        } else {
            if previousChoice == .zero {
                self.currentOrderedChoices[dropZoneIndex] = choice
                self.updateChoiceState(for: choice, to: .ordered(order: dropZoneIndex))
            } else if self.isMovable(choice: previousChoice) {
                self.currentOrderedChoices[dropZoneIndex] = choice
                self.updateChoiceState(for: previousChoice, to: .idle)
                self.updateChoiceState(for: choice, to: .ordered(order: dropZoneIndex))
            } else {
                self.updateChoiceState(for: choice, to: .idle)
            }
        }
    }

    private func isMovable(choice: CoordinatorFindTheRightOrderChoiceModel) -> Bool {
        self.uiModel.value.choices.first(where: { choice.id == $0.id })!.isDraggable
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
