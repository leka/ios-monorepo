// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorAssociateCategories

public class TTSCoordinatorAssociateCategories: TTSGameplayCoordinatorProtocol, ExerciseCompletionObservable {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel], action: NewExerciseAction? = nil, validation: NewExerciseOptions.Validation = .init()) {
        self.rawChoices = choices
        self.validation = validation

        self.gameplay = NewGameplayAssociateCategories(choices: choices.map {
            .init(id: $0.id, category: $0.category)
        })

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
        self.validationEnabled.value = (validation.type == .manual) ? false : nil
    }

    public convenience init(model: CoordinatorAssociateCategoriesModel, action: NewExerciseAction? = nil, validation: NewExerciseOptions.Validation = .init()) {
        self.init(choices: model.choices, action: action, validation: validation)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationEnabled = CurrentValueSubject<Bool?, Never>(nil)
    public private(set) var validation: NewExerciseOptions.Validation

    public var didComplete: PassthroughSubject<Void, Never> = .init()

    public func processUserSelection(choiceID: UUID) {
        guard let choice = self.rawChoices.first(where: { $0.id == choiceID }) else {
            return
        }

        guard !self.selectedChoices.contains(where: { $0.id == choice.id }) else {
            self.selectedChoices.removeAll { $0.id == choice.id }
            self.updateChoiceState(for: choice, to: .idle)
            return
        }

        self.selectedChoices.append(choice)
        self.updateChoiceState(for: choice, to: .selected)

        guard self.selectedChoices.count > 1 else {
            return
        }

        let results = self.gameplay.process(choiceIDs: [self.selectedChoices.map(\.id)])
        let categoryGroupSize = self.rawChoices.filter { $0.category == choice.category }.count

        let choicesToProcess = self.selectedChoices

        if results.allSatisfy(\.isCategoryCorrect) {
            logGEK.debug("Correct category")
            if self.selectedChoices.count == categoryGroupSize {
                self.selectedChoices.removeAll()
                logGEK.debug("Category completed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    choicesToProcess.forEach { choice in
                        self.updateChoiceState(for: choice, to: .correct)
                    }
                }

                if self.gameplay.isCompleted.value {
                    if self.validationEnabled.value != nil {
                        self.validationEnabled.send(false)
                    }
                    // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        logGEK.debug("Exercise completed")
                        self.didComplete.send()
                    }
                }
            }
        } else {
            logGEK.debug("Incorrect category")
            self.selectedChoices.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                choicesToProcess.forEach { choice in
                    self.updateChoiceState(for: choice, to: .idle)
                }
            }
        }
    }

    public func validateUserSelection() {
        // Nothing to do
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayAssociateCategories

    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]
    private var selectedChoices: [CoordinatorAssociateCategoriesChoiceModel] = []

    private func updateChoiceState(for choice: CoordinatorAssociateCategoriesChoiceModel, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view, disabled: state == .correct)
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
    let kDefaultChoices: [CoordinatorAssociateCategoriesChoiceModel] = [
        CoordinatorAssociateCategoriesChoiceModel(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        CoordinatorAssociateCategoriesChoiceModel(value: "Maison", category: nil, type: .text),
    ]

    let coordinator = TTSCoordinatorAssociateCategories(choices: kDefaultChoices)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
