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
        AssociateCategoriesChoice(value: "Category B", category: .categoryB),
        AssociateCategoriesChoice(value: "Category A", category: .categoryA),
        AssociateCategoriesChoice(value: "Category C", category: .categoryC),
    ]

    // MARK: Internal

    var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        log.debug("[CO] \(choice.id) - \(choice.value) - \(choice.state)")
        guard let gameplayChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }) else { return }
        self.gameplay.process(choice: gameplayChoice)
    }

    // MARK: Private

    private var gameplay: GameplayAssociateCategories
    private var cancellables = Set<AnyCancellable>()

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
}
