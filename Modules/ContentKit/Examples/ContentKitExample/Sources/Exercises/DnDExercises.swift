// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct DnDExercises: View {
    var body: some View {
        Text("DnD")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesDefault
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Categories")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Categories", color: .green)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesDefault
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("With Zones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "With Zones", color: .green)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesImages)
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("One To One")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "One To One", color: .green)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesEmojis
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Validate With Zones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Validate With Zones", color: .green)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesEmojis)
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
