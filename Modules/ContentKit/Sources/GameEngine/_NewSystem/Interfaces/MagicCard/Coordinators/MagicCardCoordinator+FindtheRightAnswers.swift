// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

// MARK: - MagicCardCoordinatorFindTheRightAnswers

public class MagicCardCoordinatorFindTheRightAnswers: MagicCardGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel],
                action: NewExerciseAction? = nil,
                options: NewExerciseOptions? = nil)
    {
        let options = options ?? NewExerciseOptions()

        self.rawChoices = options.shuffleChoices ? choices.shuffled() : choices

        self.gameplay = NewGameplayFindTheRightAnswers(
            choices: choices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                })

        self.uiModel.value.action = action
        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(card: choice.value,
                                  size: self.uiModel.value.choiceSize(for: self.gameplay.choices.count),
                                  state: .idle)
            return MagicCardUIChoiceModel(id: choice.id, view: view)
        }
    }

    public convenience init(model: MagicCardCoordinatorFindTheRightAnswersModel,
                            action: NewExerciseAction? = nil,
                            options: NewExerciseOptions? = nil)
    {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<MagicCardUIModel, Never>(.zero)

    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

    public func enableMagicCardDetection() {
        self.robot.magicCard.send(.none)
        self.robot.magicCard
            .receive(on: DispatchQueue.main)
            .sink { [weak self] card in
                guard let self,
                      !self.gameplay.isCompleted.value,
                      let choiceID = self.rawChoices.first(where: { $0.value == card })?.id else { return }
                self.processUserSelection(cardID: choiceID)
            }
            .store(in: &self.cancellables)
    }

    public func processUserSelection(cardID: UUID) {
        // TODO: (@HPezz) - Implement architecture that counts only once a card
        self.completionData.numberOfTrials += 1

        let results = self.gameplay.process(choiceIDs: [cardID])

        results.forEach { result in
            self.updateChoiceState(for: result.id, to: result.isCorrect ? .correct : .wrong)
        }

        if self.gameplay.isCompleted.value {
            logGEK.debug("Exercise completed")
            self.didComplete.send(self.completionData)
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private var robot: Robot = .shared
    private let gameplay: NewGameplayFindTheRightAnswers
    private let rawChoices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel]

    private var completionData: ExerciseCompletionData = .init()

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(card: self.rawChoices[index].value,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        let isChoiceDisabled = (state == .correct || state == .wrong)
        self.uiModel.value.choices[index] = MagicCardUIChoiceModel(id: choiceID, view: view, disabled: isChoiceDisabled)
    }
}

extension MagicCardCoordinatorFindTheRightAnswers {
    enum State {
        case idle
        case selected
        case correct
        case wrong
    }

    struct ChoiceView: View {
        // MARK: Lifecycle

        init(card: MagicCard, size: CGFloat, state: State) {
            self.card = card
            self.size = size
            self.state = state
        }

        // MARK: Internal

        var body: some View {
            switch self.state {
                case .correct:
                    MagicCardChoiceViewDefaultCorrect(magicCard: self.card, size: self.size)
                case .wrong:
                    MagicCardChoiceViewDefaultWrong(magicCard: self.card, size: self.size)
                case .selected:
                    MagicCardChoiceViewDefaultSelected(magicCard: self.card, size: self.size)
                case .idle:
                    MagicCardChoiceViewDefaultIdle(magicCard: self.card, size: self.size)
            }
        }

        // MARK: Private

        private let card: MagicCard
        private let size: CGFloat
        private let state: State
    }
}

// MARK: ExerciseEvaluationStrategy

extension MagicCardCoordinatorFindTheRightAnswers: ExerciseEvaluationStrategy {
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
                    7: [1: 3, 2: 3, 3: 4, 4: 4, 5: 5, 6: 6, 7: 6],
                    8: [1: 3, 2: 3, 3: 4, 4: 4, 5: 5, 6: 6, 7: 6, 8: 6],
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

#Preview {
    let kDefaultChoices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.emotion_disgust_leka, isRightAnswer: true),
        .init(value: MagicCard.emotion_fear_leka),
        .init(value: MagicCard.emotion_joy_leka),
        .init(value: MagicCard.emotion_sadness_leka),
        .init(value: MagicCard.emotion_anger_leka),
    ]

    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
        choices: kDefaultChoices,
        action: NewExerciseAction.robot(type: .image("robotFaceDisgusted"))
    )
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
