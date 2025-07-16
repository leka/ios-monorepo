// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorAssociateCategories

public class TTSCoordinatorAssociateCategories: TTSGameplayCoordinatorProtocol, ExerciseCompletionObservable {
    // MARK: Lifecycle

    public init(choices: [CoordinatorAssociateCategoriesChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        self.rawChoices = options.shuffleChoices ? choices.shuffled() : choices

        self.gameplay = NewGameplayAssociateCategories(choices: self.rawChoices.map {
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
        self.validationState.value = (options.validation == .manual) ? .disabled : .hidden
    }

    public convenience init(model: CoordinatorAssociateCategoriesModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.hidden)

    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

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

        if self.validationState.value == .hidden, self.selectedChoices.count > 1 {
            self.validateUserSelection()
        } else if self.validationState.value != .hidden {
            self.validationState.send(self.selectedChoices.isNotEmpty ? .enabled : .disabled)
        }
    }

    public func validateUserSelection() {
        let results = self.gameplay.process(choiceIDs: [self.selectedChoices.map(\.id)])
        guard let firstSelectedChoice = self.selectedChoices.first else { return }

        self.completionData.numberOfTrials += 1

        let categoryGroupSize = self.rawChoices.filter { $0.category == firstSelectedChoice.category }.count

        let choicesToProcess = self.selectedChoices

        if results.allSatisfy(\.isCategoryCorrect) {
            if self.selectedChoices.count == categoryGroupSize {
                self.selectedChoices.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.disableValidationState()
                    choicesToProcess.forEach { choice in
                        self.updateChoiceState(for: choice, to: .correct)
                    }
                }

                if self.gameplay.isCompleted.value {
                    // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.validationState.send(.hidden)
                        logGEK.debug("Exercise completed")
                        self.didComplete.send(self.completionData)
                    }
                }
            } else if self.validationState.value != .hidden {
                self.selectedChoices.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.validationState.send(.disabled)
                    choicesToProcess.forEach { choice in
                        self.updateChoiceState(for: choice, to: .idle)
                    }
                }
            }
        } else {
            self.selectedChoices.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.disableValidationState()
                choicesToProcess.forEach { choice in
                    self.updateChoiceState(for: choice, to: .idle)
                }
            }
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private let gameplay: NewGameplayAssociateCategories

    private let rawChoices: [CoordinatorAssociateCategoriesChoiceModel]
    private var selectedChoices: [CoordinatorAssociateCategoriesChoiceModel] = []

    private var completionData: ExerciseCompletionData = .init()

    private func updateChoiceState(for choice: CoordinatorAssociateCategoriesChoiceModel, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choice.id }) else { return }

        let view = ChoiceView(value: choice.value,
                              type: choice.type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choice.id, view: view, disabled: state == .correct)
    }

    private func disableValidationState() {
        if self.validationState.value != .hidden {
            self.validationState.send(.disabled)
        }
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

extension TTSCoordinatorAssociateCategories: ExerciseEvaluationStrategy {
    public func evaluate(in context: EvaluationContext = .practice) -> ExerciseEvaluationLevel {
        let numberOfTrials = self.completionData.numberOfTrials
        let numberOfAllowedTrials = self.getNumberOfAllowedTrials(from: self.getEvaluationLUT(for: context))

        let trialsPercentage = Double(numberOfAllowedTrials) / Double(numberOfTrials) * 100.0

        switch trialsPercentage {
            case 90...:
                return .excellent
            case 80..<90:
                return .good
            case 70..<80:
                return .average
            case 60..<70:
                return .belowAverage
            default:
                return .fail
        }
    }

    private func getEvaluationLUT(for context: EvaluationContext) -> EvaluationLUT {
        switch context {
            default:
                [
                    1: [1: 1],
                    2: [1: 1, 2: 2],
                    3: [1: 1, 2: 2, 3: 3],
                    4: [1: 2, 2: 2, 3: 3, 4: 4],
                    5: [1: 2, 2: 3, 3: 3, 4: 4, 5: 5],
                    6: [1: 3, 2: 3, 3: 4, 4: 4, 5: 5, 6: 6],
                ]
        }
    }

    private func getNumberOfAllowedTrials(from table: EvaluationLUT) -> Int {
        let numberOfRightAnswers = self.getNumberOfRightAnswers(choices: self.rawChoices)
        let numberOfChoices = self.rawChoices.count

        guard let number = table[numberOfChoices]?[numberOfRightAnswers] else {
            logGEK.error("No number of allowed trials found for \(numberOfChoices) choices and \(numberOfRightAnswers) right answers")
            fatalError("No number of allowed trials found for \(numberOfChoices) choices and \(numberOfRightAnswers) right answers")
        }

        return number
    }

    func getNumberOfRightAnswers(choices: [CoordinatorAssociateCategoriesChoiceModel]) -> Int {
        let numberOfCategories = Set(choices.map(\.category)).count
        let numberOfCategorizableChoices = choices.map { $0.category != .none }.count

        return numberOfCategorizableChoices - numberOfCategories
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
