// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

// MARK: - DnDOneToOneCoordinatorFindTheRightOrder

public class DnDOneToOneCoordinatorFindTheRightOrder: DnDOneToOneGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightOrderChoiceModel], action: Exercise.Action? = nil, validationEnabled: Bool? = nil) {
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
        self.validationEnabled.value = validationEnabled

        self.currentOrderedChoices = Array(repeating: nil, count: self.gameplay.orderedChoices.count)
        self.alreadyValidatedChoices = Array(repeating: nil, count: self.gameplay.orderedChoices.count)
    }

    public convenience init(model: CoordinatorFindTheRightOrderModel, action: Exercise.Action? = nil, validationEnabled: Bool? = nil) {
        self.init(choices: model.choices, action: action, validationEnabled: validationEnabled)
    }

    // MARK: Public

    public private(set) var uiDropZones: [DnDDropZoneNode] = []
    public private(set) var uiModel = CurrentValueSubject<DnDOneToOneUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(nil)

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
                self.disableValidation()
                if let index = self.currentOrderedChoices.firstIndex(where: { $0 == choiceID }) {
                    self.currentOrderedChoices[index] = nil
                }
            case .ended:
                guard let destinationID else {
                    self.updateChoiceState(for: choiceID, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choiceID: choiceID, destinationID: destinationID)
        }
    }

    public func validateUserSelection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let results = self.gameplay.process(choiceIDs: self.currentOrderedChoices.map { $0! })

            results.enumerated().forEach { index, result in
                let choiceID = self.rawChoices.first(where: { $0.id == result.id })!.id
                if result.correctPosition {
                    self.updateChoiceState(for: choiceID, to: .correct(order: index))
                    self.alreadyValidatedChoices[index] = choiceID
                } else {
                    self.disableValidation()
                    self.updateChoiceState(for: choiceID, to: .idle)
                    self.currentOrderedChoices[index] = nil
                }
            }
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
            if self.validationEnabled.value == nil {
                self.validateUserSelection()
            } else {
                self.validationEnabled.send(true)
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

    private func disableValidation() {
        if self.validationEnabled.value != nil {
            self.validationEnabled.send(false)
        }
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
                node.triggerDefaultIdleBehavior()
            case .dragged:
                node.triggerDefaultDraggedBehavior()
            case let .ordered(order):
                self.triggerOrderedBehavior(for: node, in: self.uiDropZones[order])
            case let .correct(order):
                self.triggerCorrectBehavior(for: node, in: self.uiDropZones[order])
        }
    }

    private func triggerOrderedBehavior(for node: DnDAnswerNode, in dropzone: SKSpriteNode) {
        node.snapToCenter(dropZone: dropzone)
        node.isDraggable = true
    }

    private func triggerCorrectBehavior(for node: DnDAnswerNode, in dropzone: SKSpriteNode) {
        node.snapToCenter(dropZone: dropzone)
        node.isDraggable = false
    }
}
