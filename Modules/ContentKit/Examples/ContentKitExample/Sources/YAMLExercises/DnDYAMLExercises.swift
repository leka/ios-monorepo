// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct DnDYAMLExercises: View {
    var body: some View {
        Text("DnD")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDGridAssociateCategoriesYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Categories")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Categories", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDGridWithZonesAssociateCategoriesYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("With Zones")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "With Zones", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDOneToOneFindTheRightOrderYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("One To One")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "One To One", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDGridWithZonesAssociateCategoriesYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Validate With Zones")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate With Zones", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDOneToOneFindTheRightOrderThenValidateYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Validate Right Order")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate Right Order", color: .green)
                }
            }
        }
    }
}

#Preview {
    DnDExercises()
}
