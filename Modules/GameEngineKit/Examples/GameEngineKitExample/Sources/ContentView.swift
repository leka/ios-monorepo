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
                    TTSViewFindTheRightAnswers()
                        .navigationTitle("Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.orange)
                .buttonStyle(.borderedProminent)

                NavigationLink("Find The Right Order", destination: {
                    TTSViewFindTheRightOrder()
                        .navigationTitle("Find The Right Order")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.green)
                .buttonStyle(.borderedProminent)

                NavigationLink("Associate Categories", destination: {
                    TTSViewAssociateCategories()
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.cyan)
                .buttonStyle(.borderedProminent)

                NavigationLink("Choose Any Answer Up To 3", destination: {
                    TTSViewChooseAnyAnswerUpToThree()
                        .navigationTitle("Choose Any Answer Up To 3")
                        .navigationBarTitleDisplayMode(.large)
                })
                .tint(.pink)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
}
