// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDGridWithZonesCoordinatorAssociateCategories

// swiftlint:disable:next type_name
public class DnDGridWithZonesCoordinatorAssociateCategories: DnDGridWithZonesGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel], action: Exercise.Action? = nil) {
        self.rawChoices = choices

        self.gameplay = NewGameplayAssociateCategories(choices: choices.map {
            .init(id: $0.id, category: $0.category)
        })

        self.uiModel.value.action = action
        self.uiDropZoneModel.action = action

        self.uiDropZoneModel.zones = self.rawChoices[0...1].map { dropzone in
            self.currentlySelectedChoices.append([dropzone])
            self.alreadyValidatedChoices.append([dropzone])
            return DnDDropZoneNode(id: dropzone.id, value: dropzone.value, type: dropzone.type, position: .zero, size: self.uiDropZoneModel.zoneSize(for: self.rawChoices[0...1].count))
        }

        self.uiModel.value.choices = self.rawChoices[2...].map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiModel.value.choiceSize(for: choices[2...].count))
        }
    }

    // MARK: Public

    public private(set) var uiDropZoneModel: DnDGridWithZonesUIDropzoneModel = .zero
    public private(set) var uiModel = CurrentValueSubject<DnDGridWithZonesUIModel, Never>(.zero)

    public func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: self.rawChoices.first(where: { $0.id == choice.id })!, to: .selected)
            case .ended:
                guard let destination else {
                    self.updateChoiceState(for: self.rawChoices.first(where: { $0.id == choice.id })!, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choice: choice, destination: destination)
        }
    }

    // MARK: Private

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]

    private var currentlySelectedChoices: [[CoordinatorAssociateCategoriesChoiceModel]] = []
    private var alreadyValidatedChoices: [[CoordinatorAssociateCategoriesChoiceModel]] = []

    private func processUserDropOnDestination(choice: DnDAnswerNode, destination: DnDDropZoneNode) {
        guard let sourceChoice = self.rawChoices.first(where: { $0.id == choice.id }),
              let destinationChoice = self.rawChoices.first(where: { $0.id == destination.id }),
              let categoryIndex = getIndexOf(destination: destinationChoice),
              !self.choiceAlreadySelected(choice: sourceChoice) else { return }

        self.currentlySelectedChoices[categoryIndex].append(sourceChoice)

        let results = self.gameplay.process(choiceIDs: self.currentlySelectedChoices.map { $0.map(\.id) })

        if results
            .first(where: { $0.id == sourceChoice.id })?.isCategoryCorrect == true
        {
            self.updateChoiceState(for: sourceChoice, to: .correct(dropZone: destination))
            self.alreadyValidatedChoices = self.currentlySelectedChoices

            if self.gameplay.isCompleted.value {
                log.debug("Exercise completed")
            }
        } else {
            self.handleIncorrectChoice(sourceChoice)
        }
    }

    private func updateChoiceState(for choice: CoordinatorAssociateCategoriesChoiceModel, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choice.id }) else { return }

        self.updateUINodeState(node: self.uiModel.value.choices[index - 2], state: state)
    }

    private func choiceAlreadySelected(choice: CoordinatorAssociateCategoriesChoiceModel) -> Bool {
        self.alreadyValidatedChoices.contains(where: { $0.contains(where: { $0.id == choice.id }) })
    }

    private func getIndexOf(destination: CoordinatorAssociateCategoriesChoiceModel) -> Int? {
        self.alreadyValidatedChoices.firstIndex(where: { $0.contains(where: { $0.id == destination.id }) })
    }

    private func handleIncorrectChoice(_ choice: CoordinatorAssociateCategoriesChoiceModel) {
        let categoryChoices = self.rawChoices.filter { $0.category == choice.category }

        if categoryChoices.count > 1 {
            self.updateChoiceState(for: choice, to: .idle)
        } else {
            self.updateChoiceState(for: choice, to: .wrong)
        }

        self.currentlySelectedChoices = self.alreadyValidatedChoices
    }
}

extension DnDGridWithZonesCoordinatorAssociateCategories {
    enum State: Equatable {
        case idle
        case selected
        case correct(dropZone: SKSpriteNode)
        case wrong
    }

    private func updateUINodeState(node: DnDAnswerNode, state: State) {
        switch state {
            case .idle:
                self.moveNodeBackToInitialPosition(node)
            case .selected:
                self.onDragAnimation(node)
                node.zPosition += 100
            case let .correct(dropzone):
                node.isDraggable = false
                node.repositionInside(dropZone: dropzone)
                node.scale(to: CGSize(width: node.size.width * 0.75, height: node.size.height * 0.75))
            case .wrong:
                node.isDraggable = false
                self.moveNodeBackToInitialPosition(node)
        }
    }

    // MARK: - Animations

    private func onDragAnimation(_ node: SKSpriteNode) {
        let wiggleAnimation = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: -4)), duration: 0.1),
            SKAction.rotate(byAngle: 0.0, duration: 0.1),
            SKAction.rotate(byAngle: CGFloat(degreesToRadian(degrees: 4)), duration: 0.1),
        ])
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
