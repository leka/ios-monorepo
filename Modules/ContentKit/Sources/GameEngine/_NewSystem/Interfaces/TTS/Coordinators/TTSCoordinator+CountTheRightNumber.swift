// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorCountTheRightNumber

public class TTSCoordinatorCountTheRightNumber: TTSGameplayCoordinatorProtocol, ExerciseCompletionObservable {
    // MARK: Lifecycle

    public init(groups: [CoordinatorCountTheRightNumberChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        self.rawGroups = groups

        self.gameplay = NewGameplayCountTheRightNumber(
            groups: self.rawGroups
                .map { .init(expected: $0.expected, choiceIDs: $0.choiceIDs) })

        self.uiModel.value.action = action
        self.totalNumberOfChoices = groups.reduce(0) { result, group in
            result + group.choiceIDs.count
        }
        self.rawGroups.forEach { group in
            group.choiceIDs.forEach {
                let view = ChoiceView(value: group.value,
                                      type: group.type,
                                      size: self.uiModel.value.choiceSize(for: self.totalNumberOfChoices),
                                      state: .idle)
                self.uiModel.value.choices.append(TTSUIChoiceModel(id: $0, view: view))
            }
        }
        if options.shuffleChoices {
            self.uiModel.value.choices.shuffle()
        }
        self.validationState.value = (options.validation == .manual) ? .disabled : .hidden
    }

    public convenience init(model: CoordinatorCountTheRightNumberModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(groups: model.groups, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.disabled)

    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

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
        self.completionData.numberOfTrials += 1

        let results = self.gameplay.process(choiceIDs: self.currentChoices)

        if self.validationState.value != .hidden {
            guard results.allSatisfy(\.isExpected), self.gameplay.isCompleted.value else {
                results.forEach { result in
                    self.updateChoiceState(for: result.id, to: .idle)
                }

                self.gameplay.reset()
                self.resetCurrentChoices()
                return
            }
        }

        results.forEach { result in
            self.updateChoiceState(for: result.id, to: result.isExpected ? .correct : .wrong)
        }

        if self.gameplay.isCompleted.value {
            withAnimation {
                self.validationState.send(.hidden)
            }
            // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logGEK.debug("Exercise completed")
                self.didComplete.send(self.completionData)
            }
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayCountTheRightNumber

    private var currentChoices: [UUID] = []
    private let totalNumberOfChoices: Int
    private let rawGroups: [CoordinatorCountTheRightNumberChoiceModel]

    private var completionData: ExerciseCompletionData = .init()

    private func resetCurrentChoices() {
        self.currentChoices = []
        self.validationState.send(.disabled)
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let groupIndex = self.rawGroups.firstIndex(where: { $0.choiceIDs.contains(where: { $0 == choiceID }) }),
              let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawGroups[groupIndex].value,
                              type: self.rawGroups[groupIndex].type,
                              size: self.uiModel.value.choiceSize(for: self.totalNumberOfChoices),
                              state: state)

        let isChoiceDisabled = (state == .correct || state == .wrong)
        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choiceID, view: view, disabled: isChoiceDisabled)
    }
}

extension TTSCoordinatorCountTheRightNumber {
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
        let kDefaultChoices: [CoordinatorCountTheRightNumberChoiceModel] = [
            .init(value: "🍎", type: .emoji, number: 4, expected: 3),
            .init(value: "🍌", type: .emoji, number: 2, expected: 1),
        ]

        let coordinator = TTSCoordinatorCountTheRightNumber(groups: kDefaultChoices)
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }

#endif
