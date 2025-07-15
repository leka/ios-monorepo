// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

// MARK: - MagicCardCoordinatorFindTheRightAnswers

public class MagicCardCoordinatorFindTheRightAnswers: MagicCardGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel], action: NewExerciseAction? = nil) {
        self.rawChoices = choices

        self.gameplay = NewGameplayFindTheRightAnswers(
            choices: choices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                })
        self.action = action
    }

    public convenience init(model: MagicCardCoordinatorFindTheRightAnswersModel, action: NewExerciseAction? = nil) {
        self.init(choices: model.choices, action: action)
    }

    // MARK: Public

    public var action: NewExerciseAction?
    public var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

    public func enableMagicCardDetection() {
        self.robot.magicCard
            .receive(on: DispatchQueue.main)
            .sink { [weak self] card in
                if self!.gameplay.isCompleted.value { return }
                self!.processUserSelection(magicCard: card)
            }
            .store(in: &self.cancellables)
    }

    public func validateCorrectAnswer() {
        // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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

    private func processUserSelection(magicCard: MagicCard) {
        guard let choiceID = self.rawChoices.first(where: { $0.value == magicCard }) else { return }

        // TODO: (@HPezz) - Implement architecture that counts only once a card
        self.completionData.numberOfTrials += 1

        _ = self.gameplay.process(choiceIDs: [choiceID.id])

        if self.gameplay.isCompleted.value {
            self.validateCorrectAnswer()
        }
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
