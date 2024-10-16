// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDCoordinatorWithZones

class DnDCoordinatorWithZones {
    // MARK: Lifecycle

    init(gameplay: GameplayAssociateCategories) {
        self.gameplay = gameplay

        self.uiDropZones = gameplay.choices[0...1].map { dropzone in
            self.currentlySelectedChoices.append([dropzone])
            self.alreadyValidatedChoices.append([dropzone])
            return DnDDropZoneNode(id: dropzone.id, value: dropzone.value, type: dropzone.type, position: .zero)
        }

        self.uiChoices.value.choices = gameplay.choices[2...].map { choice in
            DnDAnswerNode(id: choice.id, value: choice.value, type: choice.type, size: self.uiChoices.value.choiceSize)
        }
    }

    // MARK: Internal

    var uiDropZones: [DnDDropZoneNode] = []
    private(set) var uiChoices = CurrentValueSubject<DnDUIChoices, Never>(.zero)

    func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode? = nil) {
        switch event {
            case .began:
                self.updateChoiceState(for: self.gameplay.choices.first(where: { $0.id == choice.id })!, to: .selected)
            case .ended:
                guard let destination else {
                    self.updateChoiceState(for: self.gameplay.choices.first(where: { $0.id == choice.id })!, to: .idle)
                    return
                }

                self.processUserDropOnDestination(choice: choice, destination: destination)
        }
    }

    // MARK: Private

    private let gameplay: GameplayAssociateCategories
    private var currentlySelectedChoices: [[AssociateCategoriesChoice]] = []
    private var alreadyValidatedChoices: [[AssociateCategoriesChoice]] = []

    private func processUserDropOnDestination(choice: DnDAnswerNode, destination: DnDDropZoneNode) {
        guard let sourceChoice = self.gameplay.choices.first(where: { $0.id == choice.id }),
              let destinationChoice = self.gameplay.choices.first(where: { $0.id == destination.id }),
              let categoryIndex = getIndexOf(destination: destinationChoice),
              !self.choiceAlreadySelected(choice: sourceChoice) else { return }

        self.currentlySelectedChoices[categoryIndex].append(sourceChoice)
        let results = self.gameplay.process(choices: self.currentlySelectedChoices)

        if results.first(where: { $0.choice.id == sourceChoice.id })?.correctCategory == true {
            self.updateChoiceState(for: sourceChoice, to: .correct)
            self.alreadyValidatedChoices = self.currentlySelectedChoices

            if self.gameplay.isCompleted.value {
                log.debug("Exercise completed")
            }
        } else {
            self.handleIncorrectChoice(sourceChoice)
        }
    }

    private func updateChoiceState(for choice: AssociateCategoriesChoice, to state: State) {
        guard let index = self.gameplay.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        self.updateUINodeState(node: self.uiChoices.value.choices[index - 2], state: state)
    }

    private func choiceAlreadySelected(choice: AssociateCategoriesChoice) -> Bool {
        self.alreadyValidatedChoices.contains(where: { $0.contains(where: { $0.id == choice.id }) })
    }

    private func getIndexOf(destination: AssociateCategoriesChoice) -> Int? {
        self.alreadyValidatedChoices.firstIndex(where: { $0.contains(where: { $0.id == destination.id }) })
    }

    private func handleIncorrectChoice(_ choice: AssociateCategoriesChoice) {
        let categoryChoices = self.gameplay.choices.filter { $0.category == choice.category }

        if categoryChoices.count > 1 {
            self.updateChoiceState(for: choice, to: .idle)
        } else {
            self.updateChoiceState(for: choice, to: .wrong)
        }

        self.currentlySelectedChoices = self.alreadyValidatedChoices
    }
}

extension DnDCoordinatorWithZones {
    enum State: Equatable {
        case idle
        case selected
        case correct
        case wrong
    }

    private func updateUINodeState(node: DnDAnswerNode, state: State) {
        switch state {
            case .idle:
                self.moveNodeBackToInitialPosition(node)
            case .selected:
                self.onDragAnimation(node)
                node.zPosition += 100
            case .correct:
                node.isDraggable = false
                node.scale(to: CGSize(width: node.size.width * 0.75, height: node.size.height * 0.75))
                node.zPosition = 10
                self.onDropAction(node)
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
