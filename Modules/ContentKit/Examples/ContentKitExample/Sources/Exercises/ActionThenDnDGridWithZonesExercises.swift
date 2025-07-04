// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct ActionThenDnDGridWithZoneExercises: View {
    var body: some View {
        Text("Action Then DnD Grid With Zones")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesDefault,
                        action: .ipad(type: .image("sport_dance_player_man"))
                    )

                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Drag & Drop Grid With Zones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Associate", color: .orange)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesImages,
                        action: .ipad(type: .sfsymbol("star"))
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Associate", color: .orange)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesEmojis,
                        action: .ipad(type: .audio("sound_animal_duck"))
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Associate", color: .orange)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesSFSymbols,
                        action: .ipad(type: .speech("Correct answer"))
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Associate", color: .orange)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesColors,
                        action: .robot(type: .color("orange"))
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Robot Color")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Color & Associate", color: .orange)
                }

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                        choices: ExerciseData.kAssociateCategoriesWithZonesChoicesDefault,
                        action: .robot(type: .image("robotFaceHappy"))
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Robot Screen")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Screen & Associate", color: .orange)
                }
            }
        }
    }
}

#Preview {
    ActionThenDnDGridWithZoneExercises()
}
