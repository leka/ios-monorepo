// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Choose your gameplay")
                .font(.title)
                .padding()

            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    Text("TTS")
                        .font(.title)
                        .padding()

                    NavigationLink("Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Find The Right Order", destination: {
                        let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Order")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.green)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Associate Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Associate Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Memory", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = MemoryCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                        return NewMemoryView(viewModel: viewModel)
                            .navigationTitle("Memory")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }

                HStack(spacing: 20) {
                    Text("DnD")
                        .font(.largeTitle)
                        .padding()

                    NavigationLink("Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.purple)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Drag & Drop With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Drag & Drop With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.yellow)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
            }

            Text("Or choose a template")
                .font(.largeTitle)
                .padding()

            ActivityTemplateList()
        }
    }
}

#Preview {
    ContentView()
}
