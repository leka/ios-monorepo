// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class DNDCoordinatorAssociateCategories: DNDGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayAssociateCategories) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.choices.value.map { choice in
            DNDChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
        }

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedChoices in
                guard let self else { return }
                self.uiChoices.value = updatedChoices.map { choice in
                    DNDChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Public

    public static let kDefaultChoices: [AssociateCategoriesChoice] = [
        AssociateCategoriesChoice(value: "Category A", category: .categoryA),
        AssociateCategoriesChoice(value: "Category C", category: .categoryC),
        AssociateCategoriesChoice(value: "Category B", category: .categoryB),
        AssociateCategoriesChoice(value: "Category B", category: .categoryB),
        AssociateCategoriesChoice(value: "Category A", category: .categoryA),
        AssociateCategoriesChoice(value: "No match", category: nil),
    ]

    // MARK: Internal

    var uiChoices = CurrentValueSubject<[DNDChoiceModel], Never>([])

    func processUserDrop(choice: DNDChoiceModel, target: DNDChoiceModel) {
        log.debug("[CO] \(choice.id) dropped on \(target.id)")

        guard let sourceChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }),
              let destinationChoice = self.gameplay.choices.value.first(where: { $0.id == target.id })
        else {
            return
        }

        if sourceChoice.category == destinationChoice.category {
            var updatedSource = sourceChoice
            var updatedDestination = destinationChoice
            updatedSource.state = .correct
            updatedDestination.state = .correct

            self.gameplay.process(choice: updatedSource)
            self.gameplay.process(choice: updatedDestination)

            self.gameplay.checkForExerciseCompletion()
        } else {
            self.gameplay.resetGame()
        }
    }

    // MARK: Private

    private let gameplay: GameplayAssociateCategories
    private var cancellables = Set<AnyCancellable>()

    private static func stateConverter(from state: AssociateCategoriesChoiceState) -> DNDChoiceState {
        switch state {
            case .idle:
                .idle
            case .selected:
                .selected()
            case .correct:
                .correct()
        }
    }
}
