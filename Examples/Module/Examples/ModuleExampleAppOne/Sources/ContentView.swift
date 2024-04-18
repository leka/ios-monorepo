// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    var body: some View {
        HelloView(color: .mint, name: "Module Example App One")
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
