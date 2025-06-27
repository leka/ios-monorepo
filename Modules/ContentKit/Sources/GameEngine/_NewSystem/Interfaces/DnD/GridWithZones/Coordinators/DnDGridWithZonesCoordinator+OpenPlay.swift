// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesCoordinatorOpenPlay

// swiftlint:disable:next type_name
public class DnDGridWithZonesCoordinatorOpenPlay: DnDGridWithZonesGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorOpenPlayChoiceModel], action: NewExerciseAction? = nil, validation: NewExerciseOptions.Validation = .manualWithSelectionLimit()) {
        let dropZones = choices.filter(\.isDropzone)
        let nodes = choices.filter { $0.isDropzone == false }
        self.rawChoices = Array(nodes)
        self.validation = validation

        self.uiModel.value.action = action
        self.uiDropZoneModel.action = action

        if case let .manualWithSelectionLimit(minimumToSelect, maximumToSelect) = validation {
            self.minimumToSelect = minimumToSelect ?? 0
            self.maximumToSelect = maximumToSelect ?? choices.count
            self.updateValidationState()
        } else {
            self.minimumToSelect = 0
            self.maximumToSelect = choices.count
        }

        self.uiDropZoneModel.zones = dropZones.map { dropzone in
            DnDDropZoneNode(
                id: dropzone.id,
                value: dropzone.value,
                type: dropzone.type,
                position: .zero,
                size: self.uiDropZoneModel.zoneSize(for: dropZones.count)
            )
        }

        self.uiModel.value.choices = nodes.map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiModel.value.choiceSize(for: nodes.count))
        }
    }

    public convenience init(model: CoordinatorOpenPlayModel, action: NewExerciseAction? = nil, validation: NewExerciseOptions.Validation = .manualWithSelectionLimit()) {
        self.init(choices: model.choices, action: action, validation: validation)
    }

    // MARK: Public

    public private(set) var uiDropZoneModel: DnDGridWithZonesUIDropzoneModel = .zero
    public private(set) var uiModel = CurrentValueSubject<DnDGridWithZonesUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(false)
    public private(set) var validation: NewExerciseOptions.Validation

    public var didComplete: PassthroughSubject<Void, Never> = .init()

    public func onTouch(_ event: DnDTouchEvent, choiceID: UUID, destinationID: UUID? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: choiceID, to: .dragged)
                self.currentlySelectedChoices.removeAll(where: { $0 == choiceID })
                self.updateValidationState()
            case .ended:
                guard let destinationID else {
                    self.updateChoiceState(for: choiceID, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choiceID: choiceID, destinationID: destinationID)
        }
    }

    public func validateUserSelection() {
        for choiceID in self.currentlySelectedChoices {
            self.updateChoiceState(for: choiceID, to: .correct)
        }

        // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended

        self.validationEnabled.send(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            logGEK.debug("Exercise completed")
            self.didComplete.send()
        }
    }

    // MARK: Private

    private let rawChoices: [CoordinatorOpenPlayChoiceModel]
    private let minimumToSelect: Int
    private let maximumToSelect: Int

    private var currentlySelectedChoices: [UUID] = []

    private func processUserDropOnDestination(choiceID: UUID, destinationID: UUID) {
        let destinationIndex = self.uiDropZoneModel.zones.firstIndex(where: { $0.id == destinationID })!

        self.currentlySelectedChoices.removeAll(where: { $0 == choiceID })
        self.currentlySelectedChoices.append(choiceID)
        self.updateChoiceState(for: choiceID, to: .selected(dropZone: self.uiDropZoneModel.zones[destinationIndex]))

        self.updateValidationState()
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        self.updateUINodeState(node: self.uiModel.value.choices[index], state: state)
    }

    private func updateValidationState() {
        if self.currentlySelectedChoices.count < self.minimumToSelect || self.currentlySelectedChoices.count > self.maximumToSelect {
            self.validationEnabled.send(false)
        } else {
            self.validationEnabled.send(true)
        }
    }
}

extension DnDGridWithZonesCoordinatorOpenPlay {
    enum State: Equatable {
        case idle
        case dragged
        case selected(dropZone: SKSpriteNode)
        case correct
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
            case .correct:
                self.triggerCorrectBehavior(for: node)
            case .wrong:
                node.triggerDefaultWrongBehavior()
        }
    }

    private func triggerSelectedBehavior(for node: DnDAnswerNode, in dropzone: SKSpriteNode) {
        node.repositionInside(dropZone: dropzone)
        node.isDraggable = true
    }

    private func triggerCorrectBehavior(for node: DnDAnswerNode) {
        node.isDraggable = false
    }
}
