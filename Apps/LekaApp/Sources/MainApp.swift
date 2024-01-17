// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

@main
struct LekaApp: App {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewRouter = ViewRouterDeprecated()
    @StateObject var styleManager: StyleManager = .init()
    @ObservedObject var rootOwnerViewModel = RootOwnerViewModel.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
                .environmentObject(self.styleManager)
                .environmentObject(self.viewRouter)
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                }
                .fullScreenCover(isPresented: self.$rootOwnerViewModel.isWelcomeViewPresented) {
                    WelcomeView()
                }
        }
    }
}
