// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MemoryCoordinatorAssociateCategories

public class MemoryCoordinatorAssociateCategories: MemoryGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel]) {
        self.rawChoices = choices
        self.gameplay = NewGameplayAssociateCategories(choices: choices.map {
            .init(id: $0.id, category: $0.category)
        })

        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: .idle)
            return MemoryUIChoiceModel(id: choice.id, view: view)
        }
    }

    public convenience init(model: CoordinatorAssociateCategoriesModel) {
        self.init(choices: model.choices)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<MemoryUIModel, Never>(.zero)

    public func processUserSelection(choiceID: UUID) {
        guard let choice = self.rawChoices.first(where: { $0.id == choiceID }) else {
            return
        }

        guard !self.selectedChoices.contains(where: { $0.id == choice.id }) else {
            self.selectedChoices.removeAll { $0.id == choice.id }
            self.updateChoiceState(for: choice.id, to: .idle)
            return
        }

        self.selectedChoices.append(choice)
        self.updateChoiceState(for: choice.id, to: .selected)

        guard self.selectedChoices.count > 1 else {
            return
        }

        let results = self.gameplay.process(choiceIDs: [self.selectedChoices.map(\.id)])
        let categoryGroupSize = self.rawChoices.filter { $0.category == choice.category }.count

        let choicesToProcess = self.selectedChoices

        if results.allSatisfy(\.isCategoryCorrect) {
            log.debug("Correct category")
            if self.selectedChoices.count == categoryGroupSize {
                self.selectedChoices.removeAll()
                log.debug("Category completed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    choicesToProcess.forEach { choice in
                        self.updateChoiceState(for: choice.id, to: .correct)
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
                    self.updateChoiceState(for: choice.id, to: .idle)
                }
            }
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]

    private var selectedChoices: [CoordinatorAssociateCategoriesChoiceModel] = []

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        self.uiModel.value.choices[index] = MemoryUIChoiceModel(id: choiceID, view: view, disabled: state == .correct)
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
                    NewMemoryChoiceViewDefaultSelectedOrCorrect(value: self.value, type: self.type, size: self.size)
                case .idle:
                    NewMemoryChoiceViewDefaultIdle(value: self.value, type: self.type, size: self.size)
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
    let kDefaultChoices: [CoordinatorAssociateCategoriesChoiceModel] = [
        CoordinatorAssociateCategoriesChoiceModel(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "Maison", category: nil, type: .text),
    ]

    let coordinator = MemoryCoordinatorAssociateCategories(choices: kDefaultChoices)
    let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

    return NewMemoryView(viewModel: viewModel)
}
