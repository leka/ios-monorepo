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
                NavigationLink(destination: {
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                    let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay)
                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                    return DnDGridView(viewModel: viewModel)
                        .navigationTitle("Categories")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Categories")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.purple).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay)
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("With Zones")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("With Zones")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.purple).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay)
                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                    return DnDOneToOneView(viewModel: viewModel)
                        .navigationTitle("One To One In Right Order")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("One To One In Right Order")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.purple).shadow(radius: 1))
                }
            }
        }
    }
}

#Preview {
    DnDExercises()
}
