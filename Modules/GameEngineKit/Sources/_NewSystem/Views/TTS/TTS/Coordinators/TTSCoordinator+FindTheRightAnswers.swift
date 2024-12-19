// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightAnswers

public class TTSCoordinatorFindTheRightAnswers: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(gameplay: NewGameplayFindTheRightAnswers, action: Exercise.Action? = nil) {
        self.gameplay = gameplay

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.gameplay.choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: gameplay.choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)

    public func processUserSelection(choice: TTSUIChoiceModel) {
        guard let gameplayChoice = self.gameplay.choices.first(where: { $0.id == choice.id }) else { return }

        let results = self.gameplay.process(choices: [gameplayChoice])

        results.forEach { result in
            guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == result.choice.id }) else { return }

            let view = ChoiceView(value: result.choice.value,
                                  type: result.choice.type,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: result.isCorrect ? .correct : .wrong)

            self.uiModel.value.choices[index] = TTSUIChoiceModel(id: result.choice.id, view: view)
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayFindTheRightAnswers
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
                    TTSChoiceViewDefaultCorrect(value: self.value, type: self.type, size: self.size)
                case .wrong:
                    TTSChoiceViewDefaultWrong(value: self.value, type: self.type, size: self.size)
                case .idle:
                    TTSChoiceViewDefaultIdle(value: self.value, type: self.type, size: self.size)
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
    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
