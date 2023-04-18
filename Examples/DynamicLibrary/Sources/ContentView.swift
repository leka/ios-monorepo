// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()

            Text("Hello, Dynamic Library Module Example!")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
