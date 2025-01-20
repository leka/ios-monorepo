// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
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
                        choices: ExerciseData.AssociateCategoriesChoicesDefault
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
                        choices: ExerciseData.AssociateCategoriesWithZonesChoicesDefault
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("With Zones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "With Zones", color: .green)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.FindTheRightOrderChoicesImages)
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("One To One In Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "One To One", color: .green)
                }
            }
        }
    }
}

#Preview {
    DnDExercises()
}
