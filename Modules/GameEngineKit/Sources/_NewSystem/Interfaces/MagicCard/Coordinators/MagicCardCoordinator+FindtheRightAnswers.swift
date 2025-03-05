// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

// MARK: - MagicCardCoordinatorFindTheRightAnswers

public class MagicCardCoordinatorFindTheRightAnswers: MagicCardGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightAnswersChoiceModel], action: Exercise.Action) {
        self.rawChoices = choices

        self.gameplay = NewGameplayFindTheRightAnswers(
            choices: choices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                })
        self.action = action
    }

    public convenience init(model: CoordinatorFindTheRightAnswersModel, action: Exercise.Action) {
        self.init(choices: model.choices, action: action)
    }

    // MARK: Public

    public var action: Exercise.Action

    public func enableMagicCardDetection() {
        self.robot.magicCard
            .receive(on: DispatchQueue.main)
            .sink { [weak self] card in
                if self!.gameplay.isCompleted.value { return }
                self!.processUserSelection(cardName: card.details.name)
            }
            .store(in: &self.cancellables)
    }

    public func validateCorrectAnswer() {
        // TODO: (@HPezz/@ladislas) Implement end of exercise through coordinator
        Robot.shared.run(.fire)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private var robot: Robot = .shared
    private let gameplay: NewGameplayFindTheRightAnswers
    private let rawChoices: [CoordinatorFindTheRightAnswersChoiceModel]

    private func processUserSelection(cardName: String) {
        guard let choice = self.rawChoices.first(where: { $0.value == cardName }) else { return }

        _ = self.gameplay.process(choiceIDs: [choice.id])
    }
}

#Preview {
    let kDefaultChoices: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "emotion_disgust_leka", isRightAnswer: true),
        .init(value: "emotion_fear_leka"),
        .init(value: "emotion_joy_leka"),
        .init(value: "emotion_sadness_leka"),
        .init(value: "emotion_anger_leka"),
    ]

    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
        choices: kDefaultChoices,
        action: Exercise.Action.robot(type: .image("robotFaceDisgusted"))
    )
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
