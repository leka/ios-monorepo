// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - ActionThenTTSCoordinatorFindTheRightOrder

public class ActionThenTTSCoordinatorFindTheRightOrder: ActionThenTTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(gameplay: NewGameplayFindTheRightOrder, action: Exercise.Action) {
        self.gameplay = gameplay

        self.uiChoices.value.action = action
        self.uiChoices.value.choices = self.gameplay.orderedChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiChoices.value.choiceSize,
                                  state: .idle)
            return ActionThenTTSViewUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Public

    public private(set) var uiChoices = CurrentValueSubject<ActionThenTTSViewUIChoicesWrapper, Never>(.zero)

    public func processUserSelection(choice: ActionThenTTSViewUIChoiceModel) {
        guard let gameplayChoice = self.gameplay.orderedChoices.first(where: { $0.id == choice.id }),
              !self.choiceAlreadySelected(choice: gameplayChoice) else { return }

        self.select(choice: gameplayChoice)

        if self.currentOrderedChoices.count == self.uiChoices.value.choices.count {
            _ = self.gameplay.process(choices: self.currentOrderedChoices)

            if self.gameplay.isCompleted.value {
                for (indice, choice) in self.gameplay.orderedChoices.enumerated() {
                    let view = ChoiceView(value: choice.value,
                                          type: choice.type,
                                          size: self.uiChoices.value.choiceSize,
                                          state: .correct(order: indice + 1))

                    self.uiChoices.value.choices[indice] = ActionThenTTSViewUIChoiceModel(id: choice.id, view: view)
                }
            } else {
                self.gameplay.orderedChoices.enumerated().forEach { index, choice in
                    let view = ChoiceView(value: choice.value,
                                          type: choice.type,
                                          size: self.uiChoices.value.choiceSize,
                                          state: .idle)

                    self.uiChoices.value.choices[index] = ActionThenTTSViewUIChoiceModel(id: choice.id, view: view)
                }
            }

            self.currentOrderedChoices.removeAll()
        }
    }

    // MARK: Private

    private var currentOrderedChoices: [NewGameplayFindTheRightOrderChoice] = []

    private let gameplay: NewGameplayFindTheRightOrder

    private var currentOrderedChoicesIndex: Int {
        self.currentOrderedChoices.count
    }

    private func choiceAlreadySelected(choice: NewGameplayFindTheRightOrderChoice) -> Bool {
        self.currentOrderedChoices.contains(where: { $0.id == choice.id })
    }

    private func select(choice: NewGameplayFindTheRightOrderChoice) {
        guard let index = self.uiChoices.value.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        self.currentOrderedChoices.append(choice)

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiChoices.value.choiceSize,
                              state: .selected(order: self.currentOrderedChoicesIndex))

        self.uiChoices.value.choices[index] = ActionThenTTSViewUIChoiceModel(id: choice.id, view: view)
    }
}

extension ActionThenTTSCoordinatorFindTheRightOrder {
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
    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultChoices)
    let coordinator = ActionThenTTSCoordinatorFindTheRightOrder(gameplay: gameplay, action: .robot(type: .color("red")))
    let viewModel = ActionThenTTSViewViewModel(coordinator: coordinator)

    return ActionThenTTSView(viewModel: viewModel)
}
