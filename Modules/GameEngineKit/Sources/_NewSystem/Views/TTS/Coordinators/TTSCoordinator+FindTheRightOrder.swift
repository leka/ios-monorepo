// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightOrder

public class TTSCoordinatorFindTheRightOrder: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightOrderChoiceModel], action: Exercise.Action? = nil, validationEnabled: Bool? = nil) {
        self.rawChoices = choices
        self.gameplay = NewGameplayFindTheRightOrder(
            choices: choices.map { .init(id: $0.id) }
        )
        self.uiModel.value.action = action
        self.uiModel.value.choices = choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
        self.validationEnabled.value = validationEnabled
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(nil)

    public func processUserSelection(choiceID: UUID) {
        if self.validationEnabled.value == nil {
            guard !self.choiceAlreadySelected(choiceID: choiceID) else { return }

            self.currentOrderedChoices.append(choiceID)
            self.updateChoiceState(for: choiceID, to: .selected(order: self.currentOrderedChoicesIndex))
            if self.currentOrderedChoices.count == self.rawChoices.count {
                self.validateUserSelection()
            }
        } else {
            var choiceState: State {
                if let index = currentOrderedChoices.firstIndex(where: { $0 == choiceID }) {
                    self.currentOrderedChoices.remove(at: index)
                    return .idle
                } else {
                    self.currentOrderedChoices.append(choiceID)
                    return .selected(order: self.currentOrderedChoicesIndex)
                }
            }

            self.updateChoiceState(for: choiceID, to: choiceState)
            if case .idle = choiceState {
                for (index, id) in self.currentOrderedChoices.enumerated() {
                    self.updateChoiceState(for: id, to: .selected(order: index + 1))
                }
            }
            self.validationEnabled.send(self.currentOrderedChoices.isNotEmpty)
        }
    }

    public func validateUserSelection() {
        _ = self.gameplay.process(choiceIDs: self.currentOrderedChoices)

        if self.gameplay.isCompleted.value {
            for (indice, id) in self.currentOrderedChoices.enumerated() {
                self.updateChoiceState(for: id, to: .correct(order: indice + 1))
            }
        } else {
            self.currentOrderedChoices.forEach { id in
                self.updateChoiceState(for: id, to: .idle)
            }
        }

        self.currentOrderedChoices.removeAll()
    }

    // MARK: Private

    private var currentOrderedChoices: [UUID] = []
    private let gameplay: NewGameplayFindTheRightOrder
    private let rawChoices: [CoordinatorFindTheRightOrderChoiceModel]

    private var currentOrderedChoicesIndex: Int {
        self.currentOrderedChoices.count
    }

    private func choiceAlreadySelected(choiceID: UUID) -> Bool {
        self.currentOrderedChoices.contains(where: { $0 == choiceID })
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        if case .correct = state {
            self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choiceID, view: view, disabled: true)
        } else {
            self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choiceID, view: view, disabled: false)
        }
    }
}

extension TTSCoordinatorFindTheRightOrder {
    enum State {
        case idle
        case selected(order: Int)
        case correct(order: Int)
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
                case let .selected(order):
                    TTSChoiceView(value: self.value, type: self.type, size: self.size)
                        .overlay {
                            Image(systemName: "\(order).circle.fill")
                                .resizable()
                                .frame(width: self.size, height: self.size)
                                .opacity(0.4)
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        }
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
    let kDefaultChoices: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "Choice 3", alreadyOrdered: false),
        .init(value: "Choice 2", alreadyOrdered: false),
        .init(value: "Choice 5", alreadyOrdered: true),
        .init(value: "Choice 1", alreadyOrdered: false),
        .init(value: "Choice 6", alreadyOrdered: false),
        .init(value: "Choice 4", alreadyOrdered: false),
    ]

    let coordinator = TTSCoordinatorFindTheRightOrder(choices: kDefaultChoices)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
