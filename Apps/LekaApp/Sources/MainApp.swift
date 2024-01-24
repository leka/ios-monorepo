// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

@main
struct LekaApp: App {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var styleManager: StyleManager = .shared
    @ObservedObject var rootOwnerViewModel = RootOwnerViewModel.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                }
                .fullScreenCover(isPresented: self.$rootOwnerViewModel.isWelcomeViewPresented) {
                    WelcomeView()
                }
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
        }
    }
}
