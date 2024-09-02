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
                    Text("Find The Right Answers")
                        .font(.largeTitle)
                })
                .tint(.orange)
                .buttonStyle(.borderedProminent)

                NavigationLink("Find The Right Order", destination: {
                    Text("Find The Right Order")
                        .font(.largeTitle)
                })
                .tint(.green)
                .buttonStyle(.borderedProminent)

                NavigationLink("Associate Categories", destination: {
                    Text("Associate Categories")
                        .font(.largeTitle)
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
