// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

@main
struct LekaActivityUIExplorerApp: App {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var styleManager: StyleManager = .init()

    var body: some Scene {
        WindowGroup {
            NavigationView()
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
                .environmentObject(self.styleManager)
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                }
        }
    }
}
