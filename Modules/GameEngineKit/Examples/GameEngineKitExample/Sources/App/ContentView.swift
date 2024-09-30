// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Choose your gameplay")
                .font(.largeTitle)
                .padding()

            VStack {
                HStack(spacing: 20) {
                    NavigationLink("Find The Right Answers", destination: {
                        let gameplay = GameplayFindTheRightAnswers(choices: GameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }

                NavigationLink("Find The Right Order", destination: {
                    let gameplay = GameplayFindTheRightOrder(choices: GameplayFindTheRightOrder.kDefaultChoices)
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
                    Text("Find the right categories: (1/3), (2/5), (4/6)")
                        .font(.title)
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.cyan)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
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
