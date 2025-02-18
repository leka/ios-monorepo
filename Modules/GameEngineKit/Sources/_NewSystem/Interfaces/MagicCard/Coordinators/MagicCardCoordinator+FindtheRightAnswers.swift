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

    public init(choices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel], action: Exercise.Action) {
        self.rawChoices = choices

        self.gameplay = NewGameplayFindTheRightAnswers(
            choices: choices
                .map { .init(id: $0.id, isRightAnswer: $0.isRightAnswer)
                })
        self.action = action
    }

    // MARK: Public

    public var action: Exercise.Action

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
        // TODO: (@HPezz/@ladislas) Implement end of exercise through coordinator
        Robot.shared.run(.fire)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private var robot: Robot = .shared
    private let gameplay: NewGameplayFindTheRightAnswers
    private let rawChoices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel]

    private func processUserSelection(magicCard: MagicCard) {
        guard let choiceID = self.rawChoices.first(where: { $0.value == magicCard }) else { return }

        _ = self.gameplay.process(choiceIDs: [choiceID.id])
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
        action: Exercise.Action.robot(type: .image("robotFaceDisgusted"))
    )
    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

    return MagicCardView(viewModel: viewModel)
}
