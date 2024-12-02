// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDOneToOneCoordinatorFindTheRightOrder

// swiftlint:disable:next type_name
public class DnDOneToOneCoordinatorFindTheRightOrder: DnDOneToOneGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(gameplay: NewGameplayFindTheRightOrder) {
        self.gameplay = gameplay

        self.uiChoices.value.choices = gameplay.orderedChoices.map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiChoices.value.choiceSize)
        }

        self.uiDropZones = self.uiChoices.value.choices.map { node in
            DnDDropZoneNode(node: node)
        }

        self.currentOrderedChoices = Array(repeating: .zero, count: gameplay.orderedChoices.count)
        self.alreadyValidatedChoices = Array(repeating: .zero, count: gameplay.orderedChoices.count)
    }

    // MARK: Public

    public private(set) var uiDropZones: [DnDDropZoneNode] = []
    public private(set) var uiChoices = CurrentValueSubject<DnDUIChoices, Never>(.zero)

    public func setAlreadyOrderedNodes() {
        self.gameplay.orderedChoices.enumerated().forEach { index, choice in
            if choice.alreadyOrdered {
                self.updateChoiceState(for: choice, to: .correct(order: index))
                self.currentOrderedChoices[index] = choice
                self.alreadyValidatedChoices[index] = choice
            }
        }
    }

    public func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: self.gameplay.orderedChoices.first(where: { $0.id == choice.id })!, to: .selected)
            case .ended:
                guard let destination else {
                    self.updateChoiceState(for: self.gameplay.orderedChoices.first(where: { $0.id == choice.id })!, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choice: choice, destination: destination)
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayFindTheRightOrder

    private var currentOrderedChoices: [NewGameplayFindTheRightOrderChoice] = []
    private var alreadyValidatedChoices: [NewGameplayFindTheRightOrderChoice] = []

    private func processUserDropOnDestination(choice: DnDAnswerNode, destination: DnDDropZoneNode) {
        guard let sourceChoice = self.gameplay.orderedChoices.first(where: { $0.id == choice.id }),
              let destinationIndex = self.uiDropZones.firstIndex(where: { $0.id == destination.id }),
              !self.choiceAlreadySelected(choice: sourceChoice) else { return }

        self.order(choice: sourceChoice, dropZoneIndex: destinationIndex)
        if self.currentOrderedChoices.doesNotContain(.zero) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let results = self.gameplay.process(choices: self.currentOrderedChoices)

                results.enumerated().forEach { index, result in
                    if result.correctPosition {
                        self.updateChoiceState(for: result.choice, to: .correct(order: index))
                        self.alreadyValidatedChoices[index] = result.choice
                    } else {
                        self.updateChoiceState(for: result.choice, to: .idle)
                        self.currentOrderedChoices[index] = .zero
                    }
                }
            }
        }
    }

    private func updateChoiceState(for choice: NewGameplayFindTheRightOrderChoice, to state: State) {
        guard let index = self.gameplay.orderedChoices.firstIndex(where: { $0.id == choice.id }) else { return }

        self.updateUINodeState(node: self.uiChoices.value.choices[index], state: state)
    }

    private func choiceAlreadySelected(choice: NewGameplayFindTheRightOrderChoice) -> Bool {
        self.alreadyValidatedChoices.contains(where: { $0.id == choice.id })
    }

    private func order(choice: NewGameplayFindTheRightOrderChoice, dropZoneIndex: Int) {
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

    private func isMovable(choice: NewGameplayFindTheRightOrderChoice) -> Bool {
        self.uiChoices.value.choices.first(where: { choice.id == $0.id })!.isDraggable
    }
}

extension DnDOneToOneCoordinatorFindTheRightOrder {
    enum State: Equatable {
        case idle
        case selected
        case ordered(order: Int)
        case correct(order: Int)
    }

    private func updateUINodeState(node: DnDAnswerNode, state: State) {
        switch state {
            case .idle:
                self.moveNodeBackToInitialPosition(node)
            case .selected:
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
