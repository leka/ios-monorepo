// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightOrder

class TTSCoordinatorFindTheRightOrder: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayFindTheRightOrder) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.orderedChoices.map { choice in
            TTSChoiceModel(id: choice.id, value: choice.value, state: .idle)
        }
    }

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        guard !self.choiceAlreadySelected(choice: choice) else { return }

        self.select(choice: choice)

        if self.currentOrderedChoices.count == self.uiChoices.value.count {
            _ = self.gameplay.process(choices: self.currentOrderedChoices.map {
                FindTheRightOrderChoice(id: $0.id, value: $0.value)
            })

            if self.gameplay.isCompleted.value {
                for (indice, choice) in self.uiChoices.value.enumerated() {
                    var choice = choice
                    choice.state = .correct(order: indice + 1)
                    self.uiChoices.value[indice] = choice
                }
            } else {
                self.uiChoices.value = self.uiChoices.value.map {
                    var choice = $0
                    choice.state = .idle
                    return choice
                }
            }

            self.currentOrderedChoices.removeAll()
        }
    }

    // MARK: Private

    private var currentOrderedChoices: [TTSChoiceModel] = []

    private let gameplay: GameplayFindTheRightOrder

    private var currentOrderedChoicesIndex: Int {
        self.currentOrderedChoices.count
    }

    private func choiceAlreadySelected(choice: TTSChoiceModel) -> Bool {
        self.currentOrderedChoices.contains(where: { $0.id == choice.id })
    }

    private func select(choice: TTSChoiceModel) {
        guard let index = self.uiChoices.value.firstIndex(where: { $0.id == choice.id }) else { return }

        self.currentOrderedChoices.append(choice)

        self.uiChoices.value[index].state = .selected(order: self.currentOrderedChoicesIndex)
    }
}

#Preview {
    let gameplay = GameplayFindTheRightOrder(choices: GameplayFindTheRightOrder.kDefaultChoices)
    let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
