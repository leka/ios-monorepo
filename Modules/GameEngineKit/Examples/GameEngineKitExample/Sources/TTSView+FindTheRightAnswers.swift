// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

let kFindTheRightAnswersChoices: [FindTheRightAnswersChoice] = [
    FindTheRightAnswersChoice(value: "Choice 1\nCorrect", isRightAnswer: true),
    FindTheRightAnswersChoice(value: "Choice 2", isRightAnswer: false),
    FindTheRightAnswersChoice(value: "Choice 3\nCorrect", isRightAnswer: true),
    FindTheRightAnswersChoice(value: "Choice 4", isRightAnswer: false),
    FindTheRightAnswersChoice(value: "Choice 5\nCorrect", isRightAnswer: true),
    FindTheRightAnswersChoice(value: "Choice 6", isRightAnswer: false),
]

// MARK: - TTSCoordinatorFindTheRightAnswers

class TTSCoordinatorFindTheRightAnswers: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayFindTheRightAnswers) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.choices.value.map { choice in
            TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
        }

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] choices in
                self?.uiChoices.value = choices.map { choice in
                    TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        log.debug("[CO] \(choice.id) - \(choice.value.replacingOccurrences(of: "\n", with: " ")) - \(choice.state)")
        guard let gameplayChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }) else { return }
        self.gameplay.process(choice: gameplayChoice)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: GameplayFindTheRightAnswers

    private static func stateConverter(from state: FindTheRightAnswersChoiceState) -> TTSChoiceState {
        switch state {
            case .idle:
                .idle
            case .selected:
                .selected
            case .correct:
                .correct
            case .wrong:
                .wrong
        }
    }
}

// MARK: - TTSViewFindTheRightAnswers

struct TTSViewFindTheRightAnswers: View {
    // MARK: Lifecycle

    init() {
        self.gameplay = GameplayFindTheRightAnswers(choices: kFindTheRightAnswersChoices)
        self.coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: self.gameplay)
        self.viewModel = TTSViewViewModel(coordinator: self.coordinator)
    }

    // MARK: Internal

    var body: some View {
        VStack(spacing: 50) {
            TTSView(viewModel: self.viewModel)
        }
    }

    // MARK: Private

    private var gameplay: GameplayFindTheRightAnswers
    private var coordinator: TTSCoordinatorFindTheRightAnswers
    private var viewModel: TTSViewViewModel
}

#Preview {
    TTSViewFindTheRightAnswers()
}
