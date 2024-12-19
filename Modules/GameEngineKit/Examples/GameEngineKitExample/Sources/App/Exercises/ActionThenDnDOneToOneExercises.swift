// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ActionThenDnDOneToOneExercises: View {
    var body: some View {
        Text("Action Then DnD One To One")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay,
                                                                              action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Observe Image")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay,
                                                                              action: .ipad(type: .sfsymbol("star")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Observe SFSymbol")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay,
                                                                              action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Listen Audio Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Listen Audio")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay,
                                                                              action: .ipad(type: .speech("Correct answer")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Listen Speech Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Listen Speech")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay,
                                                                              action: .robot(type: .color("red")))
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("Listen Robot Then Drag & Drop One To One")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Robot")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }
            }
        }
    }
}

#Preview {
    ActionThenDnDOneToOneExercises()
}
