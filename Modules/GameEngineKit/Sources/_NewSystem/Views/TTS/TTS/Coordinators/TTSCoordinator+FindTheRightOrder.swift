// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightOrder

public class TTSCoordinatorFindTheRightOrder: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(gameplay: NewGameplayFindTheRightOrder, action: Exercise.Action? = nil) {
        self.gameplay = gameplay

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.gameplay.orderedChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: gameplay.orderedChoices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)

    public func processUserSelection(choiceID: String) {
        guard let gameplayChoice = self.gameplay.orderedChoices.first(where: { $0.id == choiceID }),
              !self.choiceAlreadySelected(choice: gameplayChoice) else { return }

        self.select(choice: gameplayChoice)

        if self.currentOrderedChoices.count == self.uiModel.value.choices.count {
            _ = self.gameplay.process(choices: self.currentOrderedChoices)

            if self.gameplay.isCompleted.value {
                for (indice, choice) in self.gameplay.orderedChoices.enumerated() {
                    let view = ChoiceView(value: choice.value,
                                          type: choice.type,
                                          size: self.uiModel.value.choiceSize(for: self.gameplay.orderedChoices.count),
                                          state: .correct(order: indice + 1))

                    self.uiModel.value.choices[indice] = TTSUIChoiceModel(id: choice.id, view: view)
                }
            } else {
                self.gameplay.orderedChoices.enumerated().forEach { index, choice in
                    let view = ChoiceView(value: choice.value,
                                          type: choice.type,
                                          size: self.uiModel.value.choiceSize(for: self.gameplay.orderedChoices.count),
                                          state: .idle)

                    self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view)
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
        guard let index = self.uiModel.value.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        self.currentOrderedChoices.append(choice)

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiModel.value.choiceSize(for: self.gameplay.orderedChoices.count),
                              state: .selected(order: self.currentOrderedChoicesIndex))

        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view)
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
    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultChoices)
    let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
