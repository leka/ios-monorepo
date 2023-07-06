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
