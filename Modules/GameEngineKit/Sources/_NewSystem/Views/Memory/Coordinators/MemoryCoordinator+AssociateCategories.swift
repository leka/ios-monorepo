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

        self.uiChoices.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiChoices.value.choiceSize,
                                  state: .idle)
            return MemoryViewUIChoiceModel(id: choice.id, view: view)
        }
    }

    // MARK: Public

    public private(set) var uiChoices = CurrentValueSubject<MemoryViewUIChoicesWrapper, Never>(.zero)

    public func processUserSelection(choice _: MemoryViewUIChoiceModel) {
//        guard let gameplayChoice = self.rawChoices.first(where: { $0.id == choice.id }) else {
//            return
//        }
//
//        guard !self.selectedChoices.contains(where: { $0.id == gameplayChoice.id }) else {
//            self.selectedChoices.removeAll { $0.id == gameplayChoice.id }
//            self.updateChoiceState(for: gameplayChoice, to: .idle)
//            return
//        }
//
//        self.selectedChoices.append(gameplayChoice)
//        self.updateChoiceState(for: gameplayChoice, to: .selected)
//
//        guard self.selectedChoices.count > 1 else {
//            return
//        }
//
//        let results = self.gameplay.process(choices: [self.selectedChoices])
//        let categoryGroupSize = self.rawChoices.filter { $0.category == gameplayChoice.category }.count
//        let choicesToProcess = self.selectedChoices
//
//        if results.allSatisfy(\.correctCategory) {
//            if self.selectedChoices.count == categoryGroupSize {
//                self.selectedChoices.removeAll()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    choicesToProcess.forEach { choice in
//                        self.updateChoiceState(for: choice, to: .correct)
//                    }
//                }
//
//                if self.gameplay.isCompleted.value {
//                    log.info("Exercise completed")
//                }
//            }
//        } else {
//            self.selectedChoices.removeAll()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                choicesToProcess.forEach { choice in
//                    self.updateChoiceState(for: choice, to: .idle)
//                }
//            }
//        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayAssociateCategories
    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]

    private var selectedChoices: [String] = []

    private func updateChoiceState(for choice: CoordinatorAssociateCategoriesChoiceModel, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiChoices.value.choiceSize,
                              state: state)

        self.uiChoices.value.choices[index] = MemoryViewUIChoiceModel(id: choice.id, view: view)
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
