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
                        let gameplay = GameplayFindTheRightAnswers(choices: TTSCoordinatorFindTheRightAnswers.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)

                    NavigationLink("Choose Any Answer Up To 3", destination: {
                        let gameplay = GameplayChooseAnyAnswersUpToThree(choices: TTSCoordinatorChooseAnyAnswersUpToThree.kDefaultChoices)
                        let coordinator = TTSCoordinatorChooseAnyAnswersUpToThree(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Choose Any Answer Up To 3")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)

                    NavigationLink("Find The Right Order", destination: {
                        let gameplay = GameplayFindTheRightOrder(choices: TTSCoordinatorFindTheRightOrder.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Order")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.green)
                    .buttonStyle(.borderedProminent)

                    NavigationLink("Associate Categories", destination: {
                        let gameplay = GameplayAssociateCategories(choices: TTSCoordinatorAssociateCategories.kDefaultChoices)
                        let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Associate Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }

                HStack(spacing: 20) {
                    Text("DND")
                        .font(.largeTitle)
                        .padding()

                    NavigationLink("Drag & Drop Categories", destination: {
                        let gameplay = GameplayAssociateCategories(choices: DNDCoordinatorAssociateCategories.kDefaultChoices)
                        let coordinator = DNDCoordinatorAssociateCategories(gameplay: gameplay)
                        return DNDView(coordinator: coordinator)
                            .navigationTitle("Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.purple)
                    .buttonStyle(.borderedProminent)

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
