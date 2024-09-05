// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorChooseAnyAnswerUpToThree

class TTSCoordinatorChooseAnyAnswerUpToThree: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayChooseAnyAnswerUpToThree) {
        self.gameplay = gameplay

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newChoices in
                self?.uiChoices.value = newChoices.map { choice in
                    TTSChoiceModel(id: choice.id, value: choice.value, state: self?.mapState(gameState: choice.state) ?? .idle)
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        guard let correspondingGameChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }) else { return }

        self.gameplay.process(choice: correspondingGameChoice)
    }

    // MARK: Private

    private var gameplay: GameplayChooseAnyAnswerUpToThree

    private var cancellables = Set<AnyCancellable>()

    private func mapState(gameState: FindTheRightAnswersChoiceState) -> TTSChoiceState {
        switch gameState {
            case .idle:
                .idle
            case .selected:
                .selected
            default:
                .idle
        }
    }
}

// MARK: - TTSViewChooseAnyAnswerUpToThree

struct TTSViewChooseAnyAnswerUpToThree: View {
    // MARK: Lifecycle

    init() {
        self.gameplay = GameplayChooseAnyAnswerUpToThree(choices: kFindTheRightAnswersChoices)
        self.coordinator = TTSCoordinatorChooseAnyAnswerUpToThree(gameplay: self.gameplay)
        self.viewModel = TTSViewViewModel(coordinator: self.coordinator)
    }

    // MARK: Internal

    var body: some View {
        VStack(spacing: 50) {
            TTSView(viewModel: self.viewModel)
        }
    }

    // MARK: Private

    private var gameplay: GameplayChooseAnyAnswerUpToThree
    private var coordinator: TTSCoordinatorChooseAnyAnswerUpToThree
    private var viewModel: TTSViewViewModel
}
