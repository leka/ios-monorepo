// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    let appName = ModuleExampleAppTwoResources.bundle.infoDictionary?["APP_NAME"] as? String ?? "NO NAME"

    var body: some View {
        HelloView(color: .teal, name: self.appName)
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
