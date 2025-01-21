// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

// MARK: - TTSThenValidateCoordinatorNoGameplay

public class TTSThenValidateCoordinatorNoGameplay: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [TTSCoordinatorNoGameplayChoiceModel], action: Exercise.Action? = nil, minimumToSelect: Int = 0, maximumToSelect: Int? = nil) {
        self.rawChoices = choices

        self.uiModel.value.action = action
        self.minimumToSelect = minimumToSelect
        self.maximumToSelect = maximumToSelect ?? choices.count
        self.uiModel.value.choices = choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
        if minimumToSelect == 0 {
            self.validationEnabled.send(true)
        }
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(false)

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
            self.validationEnabled.send(false)
        } else {
            self.validationEnabled.send(true)
        }
    }

    public func validateUserSelection() {
        self.validationEnabled.send(false)
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
        let onReinforcerCompleted: () -> Void = {
            self.resetCurrentChoices()
            for choice in self.rawChoices {
                guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choice.id }) else { return }

                let view = ChoiceView(value: choice.value,
                                      type: choice.type,
                                      size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                                      state: .idle)

                withAnimation {
                    self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view)
                }
            }
            if self.minimumToSelect == 0 {
                self.validationEnabled.send(true)
            }
        }

        Robot.shared.run(.rainbow, onReinforcerCompleted: onReinforcerCompleted)
    }

    // MARK: Private

    private let rawChoices: [TTSCoordinatorNoGameplayChoiceModel]
    private let minimumToSelect: Int
    private let maximumToSelect: Int
    private var currentChoices: [UUID] = []

    private var cancellables = Set<AnyCancellable>()

    private func resetCurrentChoices() {
        self.currentChoices = []
    }
}

extension TTSThenValidateCoordinatorNoGameplay {
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
    let kDefaultChoices: [TTSCoordinatorNoGameplayChoiceModel] = [
        .init(value: "Choice 1\nCorrect"),
        .init(value: "Choice 2"),
        .init(value: "Choice 3\nCorrect"),
        .init(value: "checkmark.seal.fill", type: .sfsymbol),
        .init(value: "Choice 5\nCorrect"),
        .init(value: "exclamationmark.triangle.fill", type: .sfsymbol),
    ]

    let coordinator = TTSThenValidateCoordinatorNoGameplay(choices: kDefaultChoices)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
