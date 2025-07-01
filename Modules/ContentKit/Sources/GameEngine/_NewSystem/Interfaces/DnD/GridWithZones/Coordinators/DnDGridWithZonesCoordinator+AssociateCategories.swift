// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesCoordinatorAssociateCategories

// swiftlint:disable:next type_name
public class DnDGridWithZonesCoordinatorAssociateCategories: DnDGridWithZonesGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        let shuffledChoices = options.shuffleChoices ? choices.shuffled() : choices

        let dropZones = shuffledChoices.filter(\.isDropzone)
        let nodes = shuffledChoices.filter { $0.isDropzone == false }
        self.rawDropZones = Array(dropZones)
        self.rawChoices = Array(nodes)

        self.gameplay = NewGameplayAssociateCategories(choices: shuffledChoices.map {
            .init(id: $0.id, category: $0.category)
        })

        self.uiModel.value.action = action
        self.uiDropZoneModel.action = action

        self.rawDropZones.forEach { dropzone in
            self.currentlySelectedChoices.append([dropzone.id])
            self.alreadyValidatedChoices.append([dropzone.id])
        }

        self.uiDropZoneModel.zones = self.rawDropZones.map { dropzone in
            DnDDropZoneNode(
                id: dropzone.id,
                value: dropzone.value,
                type: dropzone.type,
                position: .zero,
                size: self.uiDropZoneModel.zoneSize(for: dropZones.count)
            )
        }
        self.validationState.value = (options.validation == .manual) ? .disabled : .hidden

        self.uiModel.value.choices = self.rawChoices.map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiModel.value.choiceSize(for: nodes.count))
        }
    }

    public convenience init(model: CoordinatorAssociateCategoriesModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiDropZoneModel: DnDGridWithZonesUIDropzoneModel = .zero
    public private(set) var uiModel = CurrentValueSubject<DnDGridWithZonesUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.hidden)

    public var didComplete: PassthroughSubject<Void, Never> = .init()

    public func onTouch(_ event: DnDTouchEvent, choiceID: UUID, destinationID: UUID? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: choiceID, to: .dragged)
                self.currentlySelectedChoices.enumerated().forEach { categoryIndex, category in
                    if let index = category.firstIndex(of: choiceID) {
                        self.currentlySelectedChoices[categoryIndex].remove(at: index)
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

        if self.gameplay.isCompleted.value {
            self.validationState.send(.hidden)
            // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logGEK.debug("Exercise completed")
                self.didComplete.send()
            }
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]
    private let rawDropZones: [CoordinatorAssociateCategoriesChoiceModel]

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

        if self.validationState.value != .hidden {
            self.updateChoiceState(for: choiceID, to: .selected(dropZone: self.uiDropZoneModel.zones[destinationIndex]))
            self.validationState.send(.enabled)
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

        if self.rawDropZones.contains(where: { $0.category == choice.category }) {
            self.updateChoiceState(for: choiceID, to: .idle)
        } else {
            self.updateChoiceState(for: choiceID, to: .wrong)
        }

        self.removeChoice(with: choiceID)
    }

    private func removeChoice(with choiceID: UUID) {
        for (index, category) in self.currentlySelectedChoices.enumerated() {
            if let choiceIndex = category.firstIndex(of: choiceID) {
                self.currentlySelectedChoices[index].remove(at: choiceIndex)
                break
            }
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
        node.isDraggable = true
    }

    private func triggerCorrectBehavior(for node: DnDAnswerNode, in dropzone: SKSpriteNode) {
        node.repositionInside(dropZone: dropzone)
        node.isDraggable = false
    }
}
