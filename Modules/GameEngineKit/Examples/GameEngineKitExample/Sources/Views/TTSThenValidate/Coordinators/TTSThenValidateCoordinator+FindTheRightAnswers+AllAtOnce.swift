// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSThenValidateCoordinatorFindTheRightAnswersAllAtOnce

// swiftlint:disable:next type_name
class TTSThenValidateCoordinatorFindTheRightAnswersAllAtOnce: TTSThenValidateGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayFindTheRightAnswers) {
        self.gameplay = gameplay

        self.uiChoices.value.choices = self.gameplay.choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiChoices.value.choiceSize,
                                  state: .idle)
            return TTSViewUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<TTSViewUIChoicesWrapper, Never>(.zero)

    func processUserSelection(choice: TTSViewUIChoiceModel) {
        self.currentChoices.append(choice)

        guard let index = self.uiChoices.value.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: self.gameplay.choices[index].value,
                              type: self.gameplay.choices[index].type,
                              size: self.uiChoices.value.choiceSize,
                              state: .selected)

        self.uiChoices.value.choices[index] = TTSViewUIChoiceModel(id: choice.id, view: view)
    }

    func validateUserSelection() {
        let choices = self.currentChoices.map { choice in
            self.gameplay.choices.first(where: { $0.id == choice.id })!
        }

        let results = self.gameplay.process(choices: choices)

        guard results.allSatisfy(\.isCorrect), self.gameplay.isCompleted.value else {
            results.forEach { result in
                guard let index = self.uiChoices.value.choices.firstIndex(where: { $0.id == result.choice.id }) else { return }

                let view = ChoiceView(value: result.choice.value,
                                      type: result.choice.type,
                                      size: self.uiChoices.value.choiceSize,
                                      state: .idle)

                self.uiChoices.value.choices[index] = TTSViewUIChoiceModel(id: result.choice.id, view: view)
            }

            self.gameplay.reset()
            self.resetCurrentChoices()
            return
        }

        results.forEach { result in
            guard let index = self.uiChoices.value.choices.firstIndex(where: { $0.id == result.choice.id }) else { return }

            let view = ChoiceView(value: result.choice.value,
                                  type: result.choice.type,
                                  size: self.uiChoices.value.choiceSize,
                                  state: result.isCorrect ? .correct : .wrong)

            self.uiChoices.value.choices[index] = TTSViewUIChoiceModel(id: result.choice.id, view: view)
        }

        self.resetCurrentChoices()
    }

    // MARK: Private

    private let gameplay: GameplayFindTheRightAnswers
    private var currentChoices: [TTSViewUIChoiceModel] = []
    private var cancellables = Set<AnyCancellable>()

    private func resetCurrentChoices() {
        self.currentChoices = []
    }
}

extension TTSThenValidateCoordinatorFindTheRightAnswersAllAtOnce {
    enum State {
        case idle
        case selected
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
                case .selected:
                    TTSChoiceViewDefaultSelected(value: self.value, type: self.type, size: self.size)
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
    let gameplay = GameplayFindTheRightAnswers(choices: GameplayFindTheRightAnswers.kDefaultChoices)
    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswersAllAtOnce(gameplay: gameplay)
    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

    return TTSThenValidateView(viewModel: viewModel)
}
