// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

// MARK: - TTSYAMLExercises

struct TTSYAMLExercises: View {
    var body: some View {
        Text("TTS")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightAnswersYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(model: model)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightOrderYaml)!
                    let model = CoordinatorFindTheRightOrderModel(data: exercise.payload!)
                    let coordinator = TTSCoordinatorFindTheRightOrder(model: model)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Order", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSAssociateCategoriesYaml)!
                    let model = CoordinatorAssociateCategoriesModel(data: exercise.payload!)
                    let coordinator = TTSCoordinatorAssociateCategories(model: model)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Associate Categories", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMemoryAssociateCategoriesYaml)!
                    let model = CoordinatorAssociateCategoriesModel(data: exercise.payload!)
                    let coordinator = MemoryCoordinatorAssociateCategories(model: model)
                    let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                    return NewMemoryView(viewModel: viewModel)
                        .navigationTitle("Memory")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Memory", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightAnswersThenValidateYaml)!
                    let model = CoordinatorFindTheRightAnswersModel(data: exercise.payload!)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(model: model,
                                                                        validationEnabled: false)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Validate Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate Right Answers", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightOrderThenValidateYaml)!
                    let model = CoordinatorFindTheRightOrderModel(data: exercise.payload!)
                    let coordinator = TTSCoordinatorFindTheRightOrder(model: model,
                                                                      validationEnabled: false)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Validate Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate Right Order", color: .indigo)
                }
            }
        }
    }
}

#Preview {
    TTSYAMLExercises()
}
