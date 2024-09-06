// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Choose your gameplay!")
                .font(.largeTitle)
                .padding()

            VStack(spacing: 20) {
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
                    Text("Find the right order: 1, 2, 3, 4, 5, 6")
                        .font(.title)
                        .navigationTitle("Find The Right Order")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.green)
                .buttonStyle(.borderedProminent)

                NavigationLink("Associate Categories", destination: {
                    Text("Find the right categories: (1/3), (2/5), (4/6)")
                        .font(.title)
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.cyan)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
}
