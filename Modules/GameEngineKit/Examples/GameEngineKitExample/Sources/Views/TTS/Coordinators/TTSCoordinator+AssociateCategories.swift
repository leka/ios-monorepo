// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorAssociateCategories

class TTSCoordinatorAssociateCategories: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayAssociateCategories) {
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
        guard let gameplayChoice = self.gameplay.choices.first(where: { $0.id == choice.id }) else {
            return
        }

        self.selectedChoices.append(gameplayChoice)

        if self.selectedChoices.count <= 1 {
            self.updateChoiceState(for: gameplayChoice, to: .selected)
        } else {
            let results = self.gameplay.process(choices: [self.selectedChoices])
            let categoryGroupSize = self.gameplay.choices.filter { $0.category == gameplayChoice.category }.count

            if results.allSatisfy(\.correctCategory) {
                if self.selectedChoices.count == categoryGroupSize {
                    self.selectedChoices.forEach { choice in
                        self.updateChoiceState(for: choice, to: .correct)
                    }
                    self.selectedChoices.removeAll()
                    if self.gameplay.isCompleted.value {
                        print("Exercise completed !!!!")
                    }
                } else {
                    self.selectedChoices.forEach { choice in
                        self.updateChoiceState(for: choice, to: .selected)
                    }
                }
            } else {
                self.selectedChoices.forEach { choice in
                    self.updateChoiceState(for: choice, to: .idle)
                }
                self.selectedChoices.removeAll()
            }
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let gameplay: GameplayAssociateCategories
    private var selectedChoices: [AssociateCategoriesChoice] = []

    private func updateChoiceState(for choice: AssociateCategoriesChoice, to state: State) {
        guard let index = self.gameplay.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiChoices.value.choiceSize,
                              state: state)

        self.uiChoices.value.choices[index] = TTSViewUIChoiceModel(id: choice.id, view: view)
    }
}

extension TTSCoordinatorAssociateCategories {
    enum State {
        case idle
        case selected
        case correct
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
                case .idle:
                    TTSChoiceViewDefaultIdle(value: self.value, type: self.type, size: self.size)
            }
        }

        // MARK: Private

        private let value: String
        private let size: CGFloat
        private let type: ChoiceType
        private let state: State
    }
}

#Preview {
    let gameplay = GameplayAssociateCategories(choices: GameplayAssociateCategories.kDefaultChoices)
    let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
