// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .trailing) {
                    Text("Tinder: ")
                    Text("ReactKit: ")
                    Text("Actomaton: ")
                    Text("GameplayKit: ")
                    Text("PeterRingset: ")
                }
                VStack {
                    TinderView()
                    ReactKitView()
                    ActomatonView()
                    GameplayKitView()
                    PeterRingsetView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
