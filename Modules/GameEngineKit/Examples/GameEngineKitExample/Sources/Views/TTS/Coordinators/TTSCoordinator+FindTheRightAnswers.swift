// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightAnswers

class TTSCoordinatorFindTheRightAnswers: TTSGameplayCoordinatorProtocol {
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
        guard let gameplayChoice = self.gameplay.choices.first(where: { $0.id == choice.id }) else { return }

        let results = self.gameplay.process(choices: [gameplayChoice])

        for result in results {
            guard var uiChoice = self.uiChoices.value.first(where: { $0.id == result.choice.id }) else { continue }

            guard let index = self.uiChoices.value.firstIndex(where: { $0.id == result.choice.id }) else { return }

            if result.isCorrect {
                uiChoice.state = .correct()

            } else {
                uiChoice.state = .wrong
            }

            self.uiChoices.value[index] = uiChoice
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: GameplayFindTheRightAnswers
}

#Preview {
    let gameplay = GameplayFindTheRightAnswers(choices: GameplayFindTheRightAnswers.kDefaultChoices)
    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
