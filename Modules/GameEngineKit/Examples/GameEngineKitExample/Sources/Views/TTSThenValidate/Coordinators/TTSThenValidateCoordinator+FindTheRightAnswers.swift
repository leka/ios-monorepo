// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSThenValidateCoordinatorFindTheRightAnswers

// swiftlint:disable:next type_name
class TTSThenValidateCoordinatorFindTheRightAnswers: TTSThenValidateGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayFindTheRightAnswers) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.choices.map { choice in
            TTSChoiceModel(id: choice.id, value: choice.value, state: .idle)
        }
    }

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        self.currentChoices.append(choice)

        guard let index = self.uiChoices.value.firstIndex(where: { $0.id == choice.id }) else { return }

        self.uiChoices.value[index].state = .selected()
    }

    func validateUserSelection() {
        let choices = self.currentChoices.map { choice in
            self.gameplay.choices.first(where: { $0.id == choice.id })!
        }

        let results = self.gameplay.process(choices: choices)

        for result in results {
            guard let index = self.uiChoices.value.firstIndex(where: { $0.id == result.choice.id }) else { return }

            if result.isCorrect {
                self.uiChoices.value[index].state = .correct()
            } else {
                self.uiChoices.value[index].state = .wrong
            }
        }

        self.resetCurrentChoices()
    }

    // MARK: Private

    private let gameplay: GameplayFindTheRightAnswers
    private var currentChoices: [TTSChoiceModel] = []
    private var cancellables = Set<AnyCancellable>()

    private func resetCurrentChoices() {
        self.currentChoices = []
    }
}

#Preview {
    let gameplay = GameplayFindTheRightAnswers(choices: GameplayFindTheRightAnswers.kDefaultChoices)
    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

    return TTSThenValidateView(viewModel: viewModel)
}
