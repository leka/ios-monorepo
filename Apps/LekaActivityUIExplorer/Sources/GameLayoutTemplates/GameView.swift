// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct GameView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        ZStack(alignment: .top) {
            GameBackgroundView()

            VStack(spacing: 0) {
                if !gameEngine.currentActivity.stepSequence[0].isEmpty
                    && gameEngine.currentActivity.activityType != "xylophone"
                {
                    ProgressBar()
                        .padding(.bottom, defaults.headerSpacing)
                }
                StepInstructionsButton()
                InteractionsView(templateDefaults: templateDefaults)
            }
        }
    }
}
