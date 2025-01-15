// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSThenValidateCoordinatorFindTheRightAnswers

// swiftlint:disable:next type_name
public class TTSThenValidateCoordinatorFindTheRightAnswers: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [TTSCoordinatorFindTheRightAnswersChoiceModel], action: Exercise.Action? = nil) {
        self.rawChoices = choices
        self.gameplay = NewGameplayFindTheRightAnswers(
            choices: choices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                })

        self.uiModel.value.action = action
        self.uiModel.value.choices = choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(true)

    public func processUserSelection(choice: TTSUIChoiceModel) {
        var choiceState: State {
            if let index = currentChoices.firstIndex(where: { $0 == choice.id }) {
                self.currentChoices.remove(at: index)
                return .idle
            } else {
                self.currentChoices.append(choice.id)
                return .selected
            }
        }

        guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                              state: choiceState)

        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view)
        self.validationEnabled.send(true)
    }

    public func validateUserSelection() {
        let choices = self.currentChoices.compactMap { choice in
            self.rawChoices.first(where: { $0.id == choice })?.id
        }

        let results = self.gameplay.process(choiceIDs: choices)

        results.forEach { result in
            guard let index = self.rawChoices.firstIndex(where: { $0.id == result.id }) else {
                return
            }

            let view = ChoiceView(value: self.rawChoices[index].value,
                                  type: self.rawChoices[index].type,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: result.isCorrect ? .correct : .wrong)

            self.uiModel.value.choices[index] = TTSUIChoiceModel(id: result.id, view: view)
        }

        self.resetCurrentChoices()

        self.validationEnabled.send(false)
    }

    // MARK: Private

    private let gameplay: NewGameplayFindTheRightAnswers

    private let rawChoices: [TTSCoordinatorFindTheRightAnswersChoiceModel]
    private var currentChoices: [String] = []

    private var cancellables = Set<AnyCancellable>()

    private func resetCurrentChoices() {
        self.currentChoices = []
    }
}

extension TTSThenValidateCoordinatorFindTheRightAnswers {
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
    let kDefaultChoices: [TTSCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "Choice 1\nCorrect", isRightAnswer: true),
        .init(value: "Choice 2", isRightAnswer: false),
        .init(value: "Choice 3\nCorrect", isRightAnswer: true),
        .init(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        .init(value: "Choice 5\nCorrect", isRightAnswer: true),
        .init(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]

    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(choices: kDefaultChoices)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
