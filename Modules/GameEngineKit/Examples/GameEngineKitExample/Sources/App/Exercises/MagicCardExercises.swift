// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SwiftUI

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
                        choices: ExerciseData.kFindTheRightAnswersMagicCardNumbers,
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
                        choices: ExerciseData.kFindTheRightAnswersMagicCardColors,
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
                        choices: ExerciseData.kFindTheRightAnswersMagicCardColors,
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
                        choices: ExerciseData.kFindTheRightAnswersMagicCardEmotions,
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
                        choices: ExerciseData.kFindTheRightAnswersMagicCardNumbers,
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
                        choices: ExerciseData.kFindTheRightAnswersMagicCardNumbers,
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
