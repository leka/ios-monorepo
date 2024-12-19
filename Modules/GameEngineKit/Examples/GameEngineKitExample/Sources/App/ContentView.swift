// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Choose your gameplay")
                        .font(.headline)
                        .padding()

                    TTSExercises()

                    ActionThenTTSExercises()

                    TTSThenValidateExercises()

                    ActionThenTTSThenValidateExercises()

                    DnDExercises()

                    ActionThenDnDGridExercises()

                    ActionThenDnDGridWithZoneExercises()

                    ActionThenDnDOneToOneExercises()

                    Text("Or choose a template")
                        .font(.largeTitle)
                        .padding()

                    ActivityTemplateList()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
