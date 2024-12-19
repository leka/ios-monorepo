// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ActionThenDnDGridWithZoneExercises: View {
    var body: some View {
        Text("Action Then DnD Grid With Zones")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink(destination: {
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultImageChoicesWithZones)
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                     action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Drag & Drop Grid With Zones")
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
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                     action: .ipad(type: .sfsymbol("star")))
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
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
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                     action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
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
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultImageChoicesWithZones)
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                     action: .ipad(type: .speech("Correct answer")))
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
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
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                     action: .robot(type: .color("red")))
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("Listen Robot")
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
    ActionThenDnDGridWithZoneExercises()
}
