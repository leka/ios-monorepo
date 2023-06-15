// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct LekaActivityUIExplorerApp: App {
    @StateObject var navigator = NavigationManager()
    @StateObject var gameEngine = GameEngine()
    @StateObject var defaults = GameLayoutTemplatesDefaults()
    @StateObject var configuration = GameLayoutTemplatesConfigurations()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(navigator)
                .environmentObject(gameEngine)
                .environmentObject(defaults)
                .environmentObject(configuration)
                .onAppear {
                    gameEngine.bufferActivity = ExplorerActivity(
                        type: .touchToSelect,
                        interface: .touch1
                    )
                    .makeActivity()
                }
        }
    }
}
