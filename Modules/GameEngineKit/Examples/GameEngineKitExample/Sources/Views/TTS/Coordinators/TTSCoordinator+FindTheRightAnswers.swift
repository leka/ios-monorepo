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

        self.uiChoices.value.choices = self.gameplay.choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiChoices.value.choiceSize,
                                  state: .idle)
            return TTSChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<UIChoices, Never>(.zero)

    func processUserSelection(choice: TTSChoiceModel) {
        guard let gameplayChoice = self.gameplay.choices.first(where: { $0.id == choice.id }) else { return }

        let results = self.gameplay.process(choices: [gameplayChoice])

        results.forEach { result in
            guard let index = self.uiChoices.value.choices.firstIndex(where: { $0.id == result.choice.id }) else { return }

            let view = ChoiceView(value: result.choice.value,
                                  type: result.choice.type,
                                  size: self.uiChoices.value.choiceSize,
                                  state: result.isCorrect ? .correct : .wrong)

            self.uiChoices.value.choices[index] = TTSChoiceModel(id: result.choice.id, view: view)
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: GameplayFindTheRightAnswers
}

extension TTSCoordinatorFindTheRightAnswers {
    enum State {
        case idle
        case correct
        case wrong
    }

    struct ChoiceView: View {
        // MARK: Lifecycle

        init(value: String, type: ChoiceType, size: CGFloat, state: State) {
            self.value = value
            self.type = type
            self.size = size
            self.state = state
        }

        // MARK: Internal

        var body: some View {
            switch self.state {
                case .correct:
                    TTSChoiceView(value: self.value, type: self.type, size: self.size)
                        .overlay {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                                .position(x: 200, y: 20)
                        }
                case .wrong:
                    TTSChoiceView(value: self.value, type: self.type, size: self.size)
                        .overlay {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .position(x: 200, y: 20)
                        }
                case .idle:
                    TTSChoiceView(value: self.value, type: self.type, size: self.size)
            }
        }

        // MARK: Private

        private let value: String
        private let type: ChoiceType
        private let size: CGFloat
        private let state: State
    }
}

#Preview {
    let gameplay = GameplayFindTheRightAnswers(choices: GameplayFindTheRightAnswers.kDefaultChoices)
    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
