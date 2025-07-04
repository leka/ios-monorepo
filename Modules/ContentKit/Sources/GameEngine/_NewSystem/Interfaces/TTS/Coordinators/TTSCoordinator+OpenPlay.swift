// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

// MARK: - TTSCoordinatorOpenPlay

public class TTSCoordinatorOpenPlay: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorOpenPlayChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        self.rawChoices = options.shuffleChoices ? choices.shuffled() : choices

        self.uiModel.value.action = action

        if case let .manualWithSelectionLimit(minimumToSelect, maximumToSelect) = options.validation {
            self.minimumToSelect = minimumToSelect ?? 0
            self.maximumToSelect = maximumToSelect ?? choices.count
            if self.minimumToSelect == 0 { self.validationState.send(.enabled) } else { self.validationState.send(.disabled) }
        } else {
            self.minimumToSelect = 0
            self.maximumToSelect = choices.count
        }

        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
    }

    public convenience init(model: CoordinatorOpenPlayModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.disabled)

    public var didComplete: PassthroughSubject<Void, Never> = .init()

    public func processUserSelection(choiceID: UUID) {
        var choiceState: State {
            if let index = currentChoices.firstIndex(where: { $0 == choiceID }) {
                self.currentChoices.remove(at: index)
                return .idle
            } else {
                self.currentChoices.append(choiceID)
                return .selected
            }
        }

        guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: choiceState)

        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choiceID, view: view)

        if self.currentChoices.count < self.minimumToSelect || self.currentChoices.count > self.maximumToSelect {
            self.validationState.send(.disabled)
        } else {
            self.validationState.send(.enabled)
        }
    }

    public func validateUserSelection() {
        self.validationState.send(.disabled)
        for id in self.currentChoices {
            guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == id }) else { return }

            let view = ChoiceView(value: self.rawChoices[index].value,
                                  type: self.rawChoices[index].type,
                                  size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                                  state: .correct)

            withAnimation {
                self.uiModel.value.choices[index] = TTSUIChoiceModel(id: id, view: view)
            }
        }

        self.validationState.send(.hidden)
        // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            logGEK.debug("Exercise completed")
            self.didComplete.send()
        }
    }

    // MARK: Private

    private let rawChoices: [CoordinatorOpenPlayChoiceModel]
    private let minimumToSelect: Int
    private let maximumToSelect: Int
    private var currentChoices: [UUID] = []

    private var cancellables = Set<AnyCancellable>()
}

extension TTSCoordinatorOpenPlay {
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
    let kDefaultChoices: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "Choice 1\nCorrect"),
        .init(value: "Choice 2"),
        .init(value: "Choice 3\nCorrect"),
        .init(value: "checkmark.seal.fill", type: .sfsymbol),
        .init(value: "Choice 5\nCorrect"),
        .init(value: "exclamationmark.triangle.fill", type: .sfsymbol),
    ]

    let coordinator = TTSCoordinatorOpenPlay(choices: kDefaultChoices)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
