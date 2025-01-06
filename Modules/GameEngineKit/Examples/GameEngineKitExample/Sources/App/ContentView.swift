// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    @State var selection: Int = 0

    var body: some View {
        NavigationStack {
            TabView(selection: self.$selection) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Choose your gameplay")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()

                        TTSExercises()

                        ActionThenTTSExercises()

                        TTSThenValidateExercises()

                        ActionThenTTSThenValidateExercises()

                        DnDExercises()

                        ActionThenDnDGridExercises()

                        ActionThenDnDGridWithZoneExercises()

                        ActionThenDnDOneToOneExercises()
                    }
                }
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Choose your gameplay")
                }
                .tag(0)

                VStack {
                    Text("Choose your template")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                    ActivityTemplateList()
                }
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("Choose your template")
                }
                .tag(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
