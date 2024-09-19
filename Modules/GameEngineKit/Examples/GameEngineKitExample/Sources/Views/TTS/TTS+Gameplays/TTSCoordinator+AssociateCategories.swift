// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorAssociateCategories

class TTSCoordinatorAssociateCategories: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayAssociateCategories) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.choices.value.map { choice in
            TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
        }

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newChoices in
                guard let self else { return }
                self.uiChoices.value = newChoices.map { choice in
                    TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Public

    public static let kDefaultChoices: [AssociateCategoriesChoice] = [
        AssociateCategoriesChoice(value: "Category A", category: .categoryA),
        AssociateCategoriesChoice(value: "Category C", category: .categoryC),
        AssociateCategoriesChoice(value: "Category B", category: .categoryB),
        AssociateCategoriesChoice(value: "Category D", category: .categoryD),
        AssociateCategoriesChoice(value: "Category A", category: .categoryA),
        AssociateCategoriesChoice(value: "No match", category: nil),
    ]

    // MARK: Internal

    var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        log.debug("[CO] \(choice.id) - \(choice.value) - \(choice.state)")
        guard let lastChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }) else { return }

        guard let firstChoice = self.firstChoice else {
            self.firstChoice = lastChoice
            self.selectedChoices.append(lastChoice)
            var updatedChoice = lastChoice
            updatedChoice.state = .selected
            self.gameplay.process(choice: updatedChoice)
            return
        }

        if firstChoice.category == lastChoice.category {
            self.selectedChoices.append(lastChoice)

            let groupSize = self.groupSizeForCategory(category: firstChoice.category)
            if self.selectedChoices.count == groupSize {
                for selectedChoice in self.selectedChoices {
                    var updatedChoice = selectedChoice
                    updatedChoice.state = .correct
                    self.gameplay.process(choice: updatedChoice)
                }
                self.resetSelection()
                self.gameplay.checkForExerciseCompletion()
            } else {
                var updatedChoice = lastChoice
                updatedChoice.state = .selected
                self.gameplay.process(choice: updatedChoice)
            }
        } else {
            self.gameplay.resetGame()
            self.resetSelection()
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let gameplay: GameplayAssociateCategories

    private var firstChoice: AssociateCategoriesChoice?
    private var selectedChoices: [AssociateCategoriesChoice] = []

    private static func stateConverter(from state: AssociateCategoriesChoiceState) -> TTSChoiceState {
        switch state {
            case .idle:
                .idle
            case .selected:
                .selected()
            case .correct:
                .correct()
        }
    }

    private func groupSizeForCategory(category: AssociateCategoriesChoice.Category?) -> Int {
        self.gameplay.choices.value.filter { $0.category == category }.count
    }

    private func resetSelection() {
        self.firstChoice = nil
        self.selectedChoices.removeAll()
    }
}

#Preview {
    let gameplay = GameplayAssociateCategories(choices: TTSCoordinatorAssociateCategories.kDefaultChoices)
    let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
