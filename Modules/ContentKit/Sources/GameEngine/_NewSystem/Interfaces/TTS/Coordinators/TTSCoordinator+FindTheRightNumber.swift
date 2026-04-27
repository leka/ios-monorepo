// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI
import UtilsKit

// MARK: - TTSCoordinatorFindTheRightNumber

public class TTSCoordinatorFindTheRightNumber: TTSGameplayCoordinatorProtocol, ExerciseCompletionObservable {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightAnswersChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        self.rawChoices = options.shuffleChoices ? choices.shuffled() : choices

        self.gameplay = NewGameplayFindTheRightNumber(
            choices: self.rawChoices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                },
            requestedNumber: Self.requestedNumber(from: options)
        )

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
        self.validationState.value = .disabled
    }

    public convenience init(model: CoordinatorFindTheRightAnswersModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.disabled)

    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

    public func processUserSelection(choiceID: UUID) {
        var choiceState: State {
            if let index = currentChoices.firstIndex(where: { $0 == choiceID }) {
                self.currentChoices.remove(at: index)
                return .idle
            } else {
                self.currentChoices.append(choiceID)
                return .selected
            }
        }

        self.updateChoiceState(for: choiceID, to: choiceState)
        self.validationState.send(self.currentChoices.isNotEmpty ? .enabled : .disabled)
    }

    public func validateUserSelection() {
        self.completionData.numberOfTrials += 1

        let choiceIDs = self.currentChoices.compactMap { choice in
            self.rawChoices.first(where: { $0.id == choice })?.id
        }

        let results = self.gameplay.process(choiceIDs: choiceIDs)

        guard results.allSatisfy(\.isCorrect), self.gameplay.isCompleted.value else {
            results.forEach { result in
                self.updateChoiceState(for: result.id, to: .idle)
            }

            self.gameplay.reset()
            self.resetCurrentChoices()
            return
        }

        results.forEach { result in
            self.updateChoiceState(for: result.id, to: result.isCorrect ? .correct : .wrong)
        }

        withAnimation {
            self.validationState.send(.hidden)
        }

        logGEK.debug("Exercise completed")
        self.didComplete.send(self.completionData)
    }

    // MARK: Private

    private let gameplay: NewGameplayFindTheRightNumber

    private var currentChoices: [UUID] = []
    private let rawChoices: [CoordinatorFindTheRightAnswersChoiceModel]

    private var completionData: ExerciseCompletionData = .init()

    private static func requestedNumber(from options: NewExerciseOptions) -> Int? {
        guard case let .manualWithSelectionLimit(minimumToSelect, maximumToSelect) = options.validation else {
            return nil
        }

        return maximumToSelect ?? minimumToSelect
    }

    private func resetCurrentChoices() {
        self.currentChoices = []
        self.validationState.send(.disabled)
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        let isChoiceDisabled = (state == .correct || state == .wrong)
        self.uiModel.value.choices[index] = TTSUIChoiceModel(id: choiceID, view: view, disabled: isChoiceDisabled)
    }
}

extension TTSCoordinatorFindTheRightNumber {
    enum State {
        case idle
        case selected
        case correct
        case wrong
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
                case .wrong:
                    TTSChoiceViewDefaultWrong(value: self.value, type: self.type, size: self.size)
                case .selected:
                    TTSChoiceViewDefaultSelected(value: self.value, type: self.type, size: self.size)
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

// MARK: ExerciseEvaluationStrategy

extension TTSCoordinatorFindTheRightNumber: ExerciseEvaluationStrategy {
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
        let numberOfRightAnswers = self.rawChoices.filter(\.isRightAnswer).count
        let numberOfChoices = self.rawChoices.count

        guard let number = table[numberOfChoices]?[numberOfRightAnswers] else {
            logGEK.error("No number of allowed trials found for \(numberOfChoices) choices and \(numberOfRightAnswers) right answers")
            fatalError("No number of allowed trials found for \(numberOfChoices) choices and \(numberOfRightAnswers) right answers")
        }

        return number
    }
}

#if DEBUG

    #Preview {
        let kDefaultChoices: [CoordinatorFindTheRightAnswersChoiceModel] = [
            .init(value: "Choice 1\nCorrect", isRightAnswer: true),
            .init(value: "Choice 2\nCorrect", isRightAnswer: true),
            .init(value: "Choice 3\nCorrect", isRightAnswer: true),
            .init(value: "checkmark.seal.fill", type: .sfsymbol, isRightAnswer: false),
            .init(value: "Choice 5", isRightAnswer: false),
            .init(value: "exclamationmark.triangle.fill", type: .sfsymbol, isRightAnswer: false),
        ]

        let coordinator = TTSCoordinatorFindTheRightNumber(choices: kDefaultChoices)
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }

#endif
