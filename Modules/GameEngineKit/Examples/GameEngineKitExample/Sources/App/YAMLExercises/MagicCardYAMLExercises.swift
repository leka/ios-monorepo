// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

// MARK: - MagicCardYAMLExercises

struct MagicCardYAMLExercises: View {
    var body: some View {
        Text("MagicCard")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMagicCardNumberRecognitionYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)!
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(model: model,
                                                                              action: Exercise.Action.robot(type: .image("magicCardNumbers5Five")))
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    return MagicCardView(viewModel: viewModel)
                        .navigationTitle("Number Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Number Recognition", color: .yellow)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMagicCardScreenColorRecognitionYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)!
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(model: model,
                                                                              action: Exercise.Action.robot(type: .image("magicCardColorsOrangePaint")))
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    return MagicCardView(viewModel: viewModel)
                        .navigationTitle("Screen Color Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Screen Color Recognition", color: .yellow)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMagicCardBeltColorRecognitionYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)!
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(model: model,
                                                                              action: Exercise.Action.robot(type: .color("red")))
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    return MagicCardView(viewModel: viewModel)
                        .navigationTitle("Belt Color Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Belt Color Recognition", color: .yellow)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMagicCardEmotionRecognitionYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)!
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(model: model,
                                                                              action: Exercise.Action.robot(type: .image("robotFaceDisgusted")))
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    return MagicCardView(viewModel: viewModel)
                        .navigationTitle("Emotion Recognition")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Emotion Recognition", color: .yellow)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMagicCardSpotCountingYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)!
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(model: model,
                                                                              action: Exercise.Action.robot(type: .spots(4)))
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    return MagicCardView(viewModel: viewModel)
                        .navigationTitle("Spot Counting")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Spot Counting", color: .yellow)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMagicCardFlashCountingYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)!
                    let coordinator = MagicCardCoordinatorFindTheRightAnswers(model: model,
                                                                              action: Exercise.Action.robot(type: .flash(3)))
                    let viewModel = MagicCardViewViewModel(coordinator: coordinator)

                    return MagicCardView(viewModel: viewModel)
                        .navigationTitle("Flash Counting")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Flash Counting", color: .yellow)
                }
            }
        }
    }
}

#Preview {
    MagicCardYAMLExercises()
}
