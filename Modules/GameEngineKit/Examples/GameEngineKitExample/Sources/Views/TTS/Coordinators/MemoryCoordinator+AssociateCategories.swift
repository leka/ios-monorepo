// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MemoryCoordinatorAssociateCategories

class MemoryCoordinatorAssociateCategories: TTSGameplayCoordinatorProtocol {
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

        guard !self.selectedChoices.contains(where: { $0.id == gameplayChoice.id }) else {
            self.selectedChoices.removeAll { $0.id == gameplayChoice.id }
            self.updateChoiceState(for: gameplayChoice, to: .idle)
            return
        }

        self.selectedChoices.append(gameplayChoice)
        self.updateChoiceState(for: gameplayChoice, to: .selected)

        guard self.selectedChoices.count > 1 else {
            return
        }

        let results = self.gameplay.process(choices: [self.selectedChoices])
        let categoryGroupSize = self.gameplay.choices.filter { $0.category == gameplayChoice.category }.count
        let choicesToProcess = self.selectedChoices

        if results.allSatisfy(\.correctCategory) {
            if self.selectedChoices.count == categoryGroupSize {
                self.selectedChoices.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    choicesToProcess.forEach { choice in
                        self.updateChoiceState(for: choice, to: .correct)
                    }
                }

                if self.gameplay.isCompleted.value {
                    log.info("Exercise completed")
                }
            }
        } else {
            self.selectedChoices.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                choicesToProcess.forEach { choice in
                    self.updateChoiceState(for: choice, to: .idle)
                }
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

extension MemoryCoordinatorAssociateCategories {
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
                case .correct,
                     .selected:
                    MemoryChoiceViewDefaultSelectedOrCorrect(value: self.value, type: self.type, size: self.size)
                case .idle:
                    MemoryChoiceViewDefaultIdle(value: self.value, type: self.type, size: self.size)
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
    let coordinator = MemoryCoordinatorAssociateCategories(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
