// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

// MARK: - DnDGridCoordinatorAssociateCategories

public class DnDGridCoordinatorAssociateCategories: DnDGridGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel], action: NewExerciseAction? = nil) {
        self.rawChoices = choices

        self.gameplay = NewGameplayAssociateCategories(choices: choices.map {
            .init(id: $0.id, category: $0.category)
        })

        self.uiModel.value.action = action
        self.uiModel.value.choices = choices.map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiModel.value.choiceSize(for: self.rawChoices.count))
        }
    }

    public convenience init(model: CoordinatorAssociateCategoriesModel, action: NewExerciseAction? = nil) {
        self.init(choices: model.choices, action: action)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<DnDGridUIModel, Never>(.zero)

    public var didComplete: PassthroughSubject<Void, Never> = .init()

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

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]

    private var currentlySelectedChoices: [[UUID]] = []
    private var alreadyValidatedChoices: [[UUID]] = []

    private func processUserDropOnDestination(choiceID: UUID, destinationID: UUID) {
        guard let choiceID = self.rawChoices.first(where: { $0.id == choiceID })?.id,
              let destinationID = self.rawChoices.first(where: { $0.id == destinationID })?.id,
              !self.choiceAlreadySelected(choiceID: choiceID) else { return }

        if let categoryIndex = getIndexOf(destinationID: destinationID) {
            self.currentlySelectedChoices[categoryIndex].append(choiceID)
        } else {
            self.currentlySelectedChoices.append([destinationID, choiceID])
        }

        self.updateChoiceState(for: choiceID, to: .selected)

        logGEK.debug("Selected choices :  \(self.currentlySelectedChoices)")

        let results = self.gameplay.process(choiceIDs: self.currentlySelectedChoices)

        if results.allSatisfy(\.isCategoryCorrect) {
            self.updateChoiceState(for: choiceID, to: .correct)
            if self.getIndexOf(destinationID: destinationID) == nil {
                self.updateChoiceState(for: destinationID, to: .correct)
            }

            self.alreadyValidatedChoices = self.currentlySelectedChoices

            if self.gameplay.isCompleted.value {
                // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    logGEK.debug("Exercise completed")
                    self.didComplete.send()
                }
            }
        } else {
            self.handleIncorrectChoice(choiceID)
        }
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        self.updateUINodeState(node: self.uiModel.value.choices[index], state: state)
    }

    private func choiceAlreadySelected(choiceID: UUID) -> Bool {
        self.alreadyValidatedChoices.contains(where: { $0.contains(where: { $0 == choiceID }) })
    }

    private func getIndexOf(destinationID: UUID) -> Int? {
        self.alreadyValidatedChoices.firstIndex(where: { $0.contains(where: { $0 == destinationID }) })
    }

    private func handleIncorrectChoice(_ choiceID: UUID) {
        logGEK.debug("Handle this incorrect choice \(choiceID)")
        guard let choice = self.rawChoices.first(where: { $0.id == choiceID }) else { return }
        let categoryChoices = self.rawChoices.filter { $0.category == choice.category }

        if categoryChoices.count > 1 {
            self.updateChoiceState(for: choiceID, to: .idle)
        } else {
            self.updateChoiceState(for: choiceID, to: .wrong)
        }

        self.currentlySelectedChoices = self.alreadyValidatedChoices
    }
}

extension DnDGridCoordinatorAssociateCategories {
    enum State: Equatable {
        case idle
        case dragged
        case selected
        case correct
        case wrong
    }

    private func updateUINodeState(node: DnDAnswerNode, state: State) {
        switch state {
            case .idle:
                node.triggerDefaultIdleBehavior()
            case .dragged:
                node.triggerDefaultDraggedBehavior()
            case .selected:
                self.triggerSelectBehavior(for: node)
            case .correct:
                self.triggerCorrectBehavior(for: node)
            case .wrong:
                node.triggerDefaultWrongBehavior()
        }
    }

    private func triggerSelectBehavior(for node: DnDAnswerNode) {
        node.onDropAction()
        node.isDraggable = true
    }

    private func triggerCorrectBehavior(for node: DnDAnswerNode) {
        node.isDraggable = false
    }
}
