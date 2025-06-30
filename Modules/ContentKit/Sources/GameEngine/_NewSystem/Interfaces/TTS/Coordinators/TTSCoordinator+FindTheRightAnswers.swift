// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightAnswers

public class TTSCoordinatorFindTheRightAnswers: TTSGameplayCoordinatorProtocol, ExerciseCompletionObservable {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightAnswersChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        self.rawChoices = options.shuffleChoices ? choices.shuffled() : choices

        self.gameplay = NewGameplayFindTheRightAnswers(
            choices: self.rawChoices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                })

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
        self.validationState.value = (options.validation == .manual) ? .disabled : .hidden
    }

    public convenience init(model: CoordinatorFindTheRightAnswersModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.disabled)

    public var didComplete: PassthroughSubject<Void, Never> = .init()

    public func processUserSelection(choiceID: UUID) {
        if self.validationState.value == .hidden {
            self.currentChoices.removeAll()
            self.currentChoices.append(choiceID)
            self.validateUserSelection()
        } else {
            var choiceState: State {
                if let index = currentChoices.firstIndex(where: { $0 == choiceID }) {
                    self.currentChoices.remove(at: index)
                    return .idle
                } else {
                    self.currentChoices.append(choiceID)
                    return .selected
                }
            }

            self.updateChoiceState(for: choiceID, to: choiceState)
            self.validationState.send(self.currentChoices.isNotEmpty ? .enabled : .disabled)
        }
    }

    public func validateUserSelection() {
        let choiceIDs = self.currentChoices.compactMap { choice in
            self.rawChoices.first(where: { $0.id == choice })?.id
        }

        let results = self.gameplay.process(choiceIDs: choiceIDs)

        if self.validationState.value != .hidden {
            guard results.allSatisfy(\.isCorrect), self.gameplay.isCompleted.value else {
                results.forEach { result in
                    self.updateChoiceState(for: result.id, to: .idle)
                }

                self.gameplay.reset()
                self.resetCurrentChoices()
                return
            }
        }

        results.forEach { result in
            self.updateChoiceState(for: result.id, to: result.isCorrect ? .correct : .wrong)
        }

        if self.gameplay.isCompleted.value {
            withAnimation {
                self.validationState.send(.hidden)
            }
            // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logGEK.debug("Exercise completed")
                self.didComplete.send()
            }
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayFindTheRightAnswers

    private var currentChoices: [UUID] = []
    private let rawChoices: [CoordinatorFindTheRightAnswersChoiceModel]

    private func resetCurrentChoices() {
        self.currentChoices = []
        self.validationState.send(.disabled)
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        let isChoiceDisabled = (state == .correct || state == .wrong)
        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choiceID, view: view, disabled: isChoiceDisabled)
    }
}

extension TTSCoordinatorFindTheRightAnswers {
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
                case .wrong:
                    TTSChoiceViewDefaultWrong(value: self.value, type: self.type, size: self.size)
                case .selected:
                    TTSChoiceViewDefaultSelected(value: self.value, type: self.type, size: self.size)
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

#if DEBUG

    #Preview {
        let kDefaultChoices: [CoordinatorFindTheRightAnswersChoiceModel] = [
            .init(value: "Choice 1\nCorrect", isRightAnswer: true),
            .init(value: "Choice 2", isRightAnswer: false),
            .init(value: "Choice 3\nCorrect", isRightAnswer: true),
            .init(value: "checkmark.seal.fill", type: .sfsymbol, isRightAnswer: true),
            .init(value: "Choice 5\nCorrect", isRightAnswer: true),
            .init(value: "exclamationmark.triangle.fill", type: .sfsymbol, isRightAnswer: false),
        ]

        let coordinator = TTSCoordinatorFindTheRightAnswers(choices: kDefaultChoices)
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }

#endif
