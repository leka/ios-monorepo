// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
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
                    let model = CoordinatorAssociateCategoriesModel(data: exercise.payload!)!
                    let coordinator = DnDGridCoordinatorAssociateCategories(model: model)
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Categories")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Categories", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDGridWithZonesAssociateCategoriesYaml)!
                    let model = CoordinatorAssociateCategoriesModel(data: exercise.payload!)!
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(model: model)
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("With Zones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "With Zones", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDOneToOneFindTheRightOrderYaml)!
                    let model = CoordinatorFindTheRightOrderModel(data: exercise.payload!)!
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(model: model)
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)
                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("One To One")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "One To One", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDGridWithZonesAssociateCategoriesYaml)!
                    let model = CoordinatorAssociateCategoriesModel(data: exercise.payload!)!
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(model: model,
                                                                                     validationEnabled: false)
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Validate With Zones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate With Zones", color: .green)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDnDOneToOneFindTheRightOrderThenValidateYaml)!
                    let model = CoordinatorFindTheRightOrderModel(data: exercise.payload!)!
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(model: model,
                                                                              validationEnabled: false)
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Validate Right Order")
                        .navigationBarTitleDisplayMode(.large)
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
