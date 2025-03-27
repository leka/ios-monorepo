// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
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
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Right Answers")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightOrderYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Right Order")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Order", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSAssociateCategoriesYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Associate Categories", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMemoryAssociateCategoriesYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Memory")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Memory", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightAnswersThenValidateYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Validate Right Answers")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate Right Answers", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kTTSFindTheRightOrderThenValidateYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Validate Right Order")
                        .navigationBarTitleDisplayMode(.inline)
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
