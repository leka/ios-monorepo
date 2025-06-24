// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightAnswers

public class TTSCoordinatorFindTheRightAnswers: TTSGameplayCoordinatorProtocol, ExerciseCompletionObservable {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightAnswersChoiceModel], action: NewExerciseAction? = nil, validation: NewExerciseOptions.Validation = .init()) {
        self.rawChoices = choices
        self.validation = validation
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
        self.validationEnabled.value = (validation.type == .manual) ? false : nil
    }

    public convenience init(model: CoordinatorFindTheRightAnswersModel, action: NewExerciseAction? = nil, validation: NewExerciseOptions.Validation = .init()) {
        self.init(choices: model.choices, action: action, validation: validation)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(nil)
    public private(set) var validation: NewExerciseOptions.Validation

    public var didComplete: PassthroughSubject<Void, Never> = .init()

    public func processUserSelection(choiceID: UUID) {
        if self.validationEnabled.value == nil {
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
            self.validationEnabled.send(self.currentChoices.isNotEmpty)
        }
    }

    public func validateUserSelection() {
        let choiceIDs = self.currentChoices.compactMap { choice in
            self.rawChoices.first(where: { $0.id == choice })?.id
        }

        let results = self.gameplay.process(choiceIDs: choiceIDs)

        if self.validationEnabled.value != nil {
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
            if self.validationEnabled.value != nil {
                self.validationEnabled.send(false)
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
        self.validationEnabled.value = false
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
