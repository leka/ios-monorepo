// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesCoordinatorAssociateCategories

// swiftlint:disable:next type_name
public class DnDGridWithZonesCoordinatorAssociateCategories: DnDGridWithZonesGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel], action: Exercise.Action? = nil, validationEnabled: Bool? = nil) {
        let dropZones = choices.prefix(2)
        let nodes = choices.suffix(choices.count - dropZones.count)
        self.rawChoices = Array(nodes)

        self.gameplay = NewGameplayAssociateCategories(choices: choices.map {
            .init(id: $0.id, category: $0.category)
        })

        self.uiModel.value.action = action
        self.uiDropZoneModel.action = action

        self.uiDropZoneModel.zones = dropZones.map { dropzone in
            self.currentlySelectedChoices.append([dropzone.id])
            self.alreadyValidatedChoices.append([dropzone.id])
            return DnDDropZoneNode(
                id: dropzone.id,
                value: dropzone.value,
                type: dropzone.type,
                position: .zero,
                size: self.uiDropZoneModel.zoneSize(for: dropZones.count)
            )
        }
        self.validationEnabled.value = validationEnabled

        self.uiModel.value.choices = nodes.map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiModel.value.choiceSize(for: nodes.count))
        }
    }

    // MARK: Public

    public private(set) var uiDropZoneModel: DnDGridWithZonesUIDropzoneModel = .zero
    public private(set) var uiModel = CurrentValueSubject<DnDGridWithZonesUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(nil)

    public func onTouch(_ event: DnDTouchEvent, choiceID: UUID, destinationID: UUID? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: choiceID, to: .dragged)
                self.currentlySelectedChoices.enumerated().forEach { categoryIndex, category in
                    if let index = category.firstIndex(of: choiceID) {
                        self.currentlySelectedChoices[categoryIndex].remove(at: index)
                        self.disableValidation()
                    }
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
        let results = self.gameplay.process(choiceIDs: self.currentlySelectedChoices)

        for (categoryIndex, category) in self.currentlySelectedChoices.enumerated() {
            for choiceID in category {
                if let result = results.first(where: { $0.id == choiceID }), result.isCategoryCorrect {
                    self.updateChoiceState(for: result.id, to: .correct(dropZone: self.uiDropZoneModel.zones[categoryIndex]))
                    self.alreadyValidatedChoices[categoryIndex].append(result.id)
                } else {
                    self.handleIncorrectChoice(choiceID)
                }
            }
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]

    private var currentlySelectedChoices: [[UUID]] = []
    private var alreadyValidatedChoices: [[UUID]] = []

    private func processUserDropOnDestination(choiceID: UUID, destinationID: UUID) {
        let destinationIndex = self.uiDropZoneModel.zones.firstIndex(where: { $0.id == destinationID })!

        for (categoryIndex, category) in self.currentlySelectedChoices.enumerated() {
            if let index = category.firstIndex(where: { $0 == choiceID }) {
                self.currentlySelectedChoices[categoryIndex].remove(at: index)
                break
            }
        }
        self.currentlySelectedChoices[destinationIndex].append(choiceID)

        if self.validationEnabled.value != nil {
            self.updateChoiceState(for: choiceID, to: .selected(dropZone: self.uiDropZoneModel.zones[destinationIndex]))
            self.validationEnabled.send(true)
        } else {
            self.validateUserSelection()
        }
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        self.updateUINodeState(node: self.uiModel.value.choices[index], state: state)
    }

    private func handleIncorrectChoice(_ choiceID: UUID) {
        guard let choice = self.rawChoices.first(where: { $0.id == choiceID }) else { return }
        let categoryChoices = self.rawChoices.filter { $0.category == choice.category }

        if categoryChoices.count > 1 {
            self.updateChoiceState(for: choiceID, to: .idle)
        } else {
            self.updateChoiceState(for: choiceID, to: .wrong)
        }

        self.currentlySelectedChoices = self.alreadyValidatedChoices
    }

    private func disableValidation() {
        if self.validationEnabled.value != nil {
            self.validationEnabled.send(false)
        }
    }
}

extension DnDGridWithZonesCoordinatorAssociateCategories {
    enum State: Equatable {
        case idle
        case dragged
        case selected(dropZone: SKSpriteNode)
        case correct(dropZone: SKSpriteNode)
        case wrong
    }

    private func updateUINodeState(node: DnDAnswerNode, state: State) {
        switch state {
            case .idle:
                node.triggerDefaultIdleBehavior()
            case .dragged:
                node.triggerDefaultDraggedBehavior()
            case let .selected(dropzone):
                self.triggerSelectedBehavior(for: node, in: dropzone)
            case let .correct(dropzone):
                self.triggerCorrectBehavior(for: node, in: dropzone)
            case .wrong:
                node.triggerDefaultWrongBehavior()
        }
    }

    private func triggerSelectedBehavior(for node: DnDAnswerNode, in dropzone: SKSpriteNode) {
        node.repositionInside(dropZone: dropzone)
    }

    private func triggerCorrectBehavior(for node: DnDAnswerNode, in dropzone: SKSpriteNode) {
        node.repositionInside(dropZone: dropzone)
        node.isDraggable = false
    }
}
