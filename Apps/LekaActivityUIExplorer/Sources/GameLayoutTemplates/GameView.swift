// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct GameView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        ZStack(alignment: .top) {
            GameBackgroundView()

            VStack(spacing: 0) {
                if !gameEngine.currentActivity.stepSequence[0].isEmpty
                    && gameEngine.currentActivity.activityType != .xylophone
                    && gameEngine.currentActivity.activityType != .remote
                    && gameEngine.currentActivity.activityType != .danceFreeze
                    && gameEngine.currentActivity.activityType != .melody
                    && gameEngine.currentActivity.activityType != .hideAndSeek
                {
                    ProgressBar()
                        .padding(.bottom, defaults.headerSpacing)
                }
                StepInstructionsButton()
                InteractionsView()
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var preferredColumn: NavigationSplitViewVisibility = .detailOnly

    static var gameEngine: GameEngine {
        let gameEngine = GameEngine()
        gameEngine.interface = .melody1
        return gameEngine
    }

    static var previews: some View {
        NavigationSplitView(columnVisibility: .constant(preferredColumn)) {
            Text("Hello")
        } detail: {
            GameView()
                .environmentObject(gameEngine)
                .environmentObject(GameLayoutTemplatesDefaults())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 4) {
                            Text("Hello, World")
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                    }
                }
        }
        .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
