// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct ActionThenDnDOneToOneExercises: View {
    var body: some View {
        Text("Action Then DnD One To One")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesDefault,
                                                                              action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Right Order", color: .red)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesImages,
                                                                              action: .ipad(type: .sfsymbol("star")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Right Order", color: .red)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesSFSymbols,
                                                                              action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Listen Audio Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Right Order", color: .red)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesColors,
                                                                              action: .ipad(type: .speech("Correct answer")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Listen Speech Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Right Order", color: .red)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesEmojis,
                                                                              action: .robot(type: .color("red")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Robot Color & Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Color & Right Order", color: .red)
                }

                NavigationLink {
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesImages,
                                                                              action: .robot(type: .image("robotFaceHappy")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Robot Screen & Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Screen & Right Order", color: .red)
                }
            }
        }
    }
}

#Preview {
    ActionThenDnDOneToOneExercises()
}
