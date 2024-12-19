// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSCoordinatorAssociateCategories

public class TTSCoordinatorAssociateCategories: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(gameplay: NewGameplayAssociateCategories, action: Exercise.Action? = nil) {
        self.gameplay = gameplay

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.gameplay.choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: gameplay.choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)

    public func processUserSelection(choice: TTSUIChoiceModel) {
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
            log.debug("Correct category")
            if self.selectedChoices.count == categoryGroupSize {
                self.selectedChoices.removeAll()
                log.debug("Category completed")
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
            log.debug("Incorrect category")
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
    private let gameplay: NewGameplayAssociateCategories
    private var selectedChoices: [NewGameplayAssociateCategoriesChoice] = []

    private func updateChoiceState(for choice: NewGameplayAssociateCategoriesChoice, to state: State) {
        guard let index = self.gameplay.choices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                              state: state)

        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view)
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
    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
    let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
