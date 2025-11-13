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

    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

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
        self.completionData.numberOfTrials += 1

        for (categoryIndex, category) in self.currentlySelectedChoices.enumerated() {
            for choiceID in category {
                if let result = results.first(where: { $0.id == choiceID }), result.isCategoryCorrect {
                    self.updateChoiceState(for: result.id, to: .correct(dropZone: self.uiDropZoneModel.zones[categoryIndex]))
                    self.alreadyValidatedChoices[categoryIndex].append(result.id)
                } else {
                    if self.validationState.value != .hidden {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            results.forEach { self.updateChoiceState(for: $0.id, to: .idle) }
                        }
                        self.resetCurrentChoices()
                        return
                    }
                    self.handleIncorrectChoice(choiceID)
                }
            }
        }

        if self.gameplay.isCompleted.value {
            self.validationState.send(.hidden)
            logGEK.debug("Exercise completed")
            self.didComplete.send(self.completionData)
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]
    private let rawDropZones: [CoordinatorAssociateCategoriesChoiceModel]

    private var completionData: ExerciseCompletionData = .init()

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

    private func resetCurrentChoices() {
        self.currentlySelectedChoices = []
        self.alreadyValidatedChoices = []
        self.rawDropZones.forEach { dropzone in
            self.currentlySelectedChoices.append([dropzone.id])
            self.alreadyValidatedChoices.append([dropzone.id])
        }
        self.validationState.send(.disabled)
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

// MARK: ExerciseEvaluationStrategy

extension DnDGridWithZonesCoordinatorAssociateCategories: ExerciseEvaluationStrategy {
    public func evaluate(in context: EvaluationContext = .practice) -> ExerciseEvaluationLevel {
        let numberOfTrials = self.completionData.numberOfTrials
        let numberOfAllowedTrials = self.getNumberOfAllowedTrials(from: self.getEvaluationLUT(for: context))

        let trialsPercentage = Double(numberOfAllowedTrials) / Double(numberOfTrials) * 100.0

        switch trialsPercentage {
            case 90...:
                return .excellent
            case 80..<90:
                return .good
            case 70..<80:
                return .average
            case 60..<70:
                return .belowAverage
            default:
                return .fail
        }
    }

    private func getEvaluationLUT(for context: EvaluationContext) -> EvaluationLUT {
        switch context {
            default:
                [
                    1: [1: 1],
                    2: [1: 1, 2: 2],
                    3: [1: 1, 2: 2, 3: 3],
                    4: [1: 2, 2: 2, 3: 3, 4: 4],
                    5: [1: 2, 2: 3, 3: 3, 4: 4, 5: 5],
                    6: [1: 3, 2: 3, 3: 4, 4: 4, 5: 5, 6: 6],
                ]
        }
    }

    private func getNumberOfAllowedTrials(from table: EvaluationLUT) -> Int {
        let numberOfRightAnswers = self.rawChoices.filter { $0.category != .none }.count
        let numberOfChoices = self.rawChoices.count

        guard let number = table[numberOfChoices]?[numberOfRightAnswers] else {
            logGEK.error("No number of allowed trials found for \(numberOfChoices) choices and \(numberOfRightAnswers) right answers")
            fatalError("No number of allowed trials found for \(numberOfChoices) choices and \(numberOfRightAnswers) right answers")
        }

        return number
    }
}
