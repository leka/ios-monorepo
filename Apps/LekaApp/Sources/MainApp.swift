// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

@main
struct LekaApp: App {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewRouter = ViewRouter()
    @StateObject var styleManager: StyleManager = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
                .environmentObject(self.styleManager)
                .environmentObject(self.viewRouter)
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                }
        }
    }
}
