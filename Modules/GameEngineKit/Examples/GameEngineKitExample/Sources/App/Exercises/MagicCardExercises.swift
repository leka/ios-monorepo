// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import RobotKit
import SwiftUI

// TODO: (@ladislas) to remove in the future, replaced by actual data
extension ExerciseData {
    static let MagicCardxFindTheRightAnswersxEmotions: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.emotion_disgust_leka, isRightAnswer: true),
        .init(value: MagicCard.emotion_fear_leka),
        .init(value: MagicCard.emotion_joy_leka),
        .init(value: MagicCard.emotion_sadness_leka),
        .init(value: MagicCard.emotion_anger_leka),
    ]

    static let MagicCardxFindTheRightAnswersxNumbers: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.number_0),
        .init(value: MagicCard.number_1),
        .init(value: MagicCard.number_2),
        .init(value: MagicCard.number_3),
        .init(value: MagicCard.number_4),
        .init(value: MagicCard.number_5, isRightAnswer: true),
        .init(value: MagicCard.number_6),
    ]

    static let MagicCardxFindTheRightAnswersxColors: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.color_red),
        .init(value: MagicCard.color_blue),
        .init(value: MagicCard.color_yellow),
        .init(value: MagicCard.color_green),
        .init(value: MagicCard.color_orange, isRightAnswer: true),
        .init(value: MagicCard.color_purple),
    ]
}

// MARK: - MagicCardExercises

struct MagicCardExercises: View {
    var body: some View {
        Text("MagicCard")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.MagicCardxFindTheRightAnswersxNumbers,
                        action: Exercise.Action.robot(type: .image("magicCardNumbers5Five"))
                    )
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    MagicCardView(viewModel: viewModel)
                        .navigationTitle("Number Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Number Recognition", color: .purple)
                }

                NavigationLink {
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.MagicCardxFindTheRightAnswersxColors,
                        action: Exercise.Action.robot(type: .image("magicCardColorsOrangePaint"))
                    )
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    MagicCardView(viewModel: viewModel)
                        .navigationTitle("Screen Color Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Screen Color Recognition", color: .purple)
                }

                NavigationLink {
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.MagicCardxFindTheRightAnswersxColors,
                        action: Exercise.Action.robot(type: .color("red"))
                    )
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    MagicCardView(viewModel: viewModel)
                        .navigationTitle("LED Color Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "LED Color Recognition", color: .purple)
                }

                NavigationLink {
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.MagicCardxFindTheRightAnswersxEmotions,
                        action: Exercise.Action.robot(type: .image("robotFaceDisgusted"))
                    )
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    MagicCardView(viewModel: viewModel)
                        .navigationTitle("Emotion Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Emotion Recognition", color: .purple)
                }

                NavigationLink {
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.MagicCardxFindTheRightAnswersxNumbers,
                        action: Exercise.Action.robot(type: .spots(5))
                    )
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    MagicCardView(viewModel: viewModel)
                        .navigationTitle("Spot Counting")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Spot Counting", color: .purple)
                }

                NavigationLink {
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.MagicCardxFindTheRightAnswersxNumbers,
                        action: Exercise.Action.robot(type: .flash(5))
                    )
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    MagicCardView(viewModel: viewModel)
                        .navigationTitle("Flash Counting")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Flash Counting", color: .purple)
                }
            }
        }
    }
}

#Preview {
    MagicCardExercises()
}
