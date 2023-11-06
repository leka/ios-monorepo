// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct LekaActivityUIExplorerApp: App {
    @StateObject var gameEngine = GameEngine()
    @StateObject var defaults = GameLayoutTemplatesDefaults()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(gameEngine)
                .environmentObject(defaults)
                .onAppear {
                    gameEngine.bufferActivity = ExplorerActivity(
                        type: .touchToSelect,
                        interface: .touch1
                    )
                    .makeActivity()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        gameEngine.setupGame()
                    }
                }
        }
    }
}
