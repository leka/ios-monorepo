// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ActionThenDnDGridExercises

struct ActionThenDnDGridExercises: View {
    var body: some View {
        Text("Action Then DnD Grid")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesDefault,
                        action: .ipad(type: .image("sport_dance_player_man"))
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Observe Image")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Associate", color: .yellow)
                }

                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesImages,
                        action: .ipad(type: .sfsymbol("star"))
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Associate", color: .yellow)
                }

                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesSFSymbols,
                        action: .ipad(type: .audio("sound_animal_duck"))
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Associate", color: .yellow)
                }

                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesEmojis,
                        action: .ipad(type: .speech("Correct answer"))
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Associate", color: .yellow)
                }

                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesColors,
                        action: .robot(type: .color("blue"))
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Robot Color")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Color & Associate", color: .yellow)
                }

                NavigationLink {
                    let coordinator = DnDGridCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesChoicesDefault,
                        action: .robot(type: .image("robotFaceHappy"))
                    )
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Robot Screen")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Screen & Associate", color: .yellow)
                }
            }
        }
    }
}

#Preview {
    ActionThenDnDGridExercises()
}
