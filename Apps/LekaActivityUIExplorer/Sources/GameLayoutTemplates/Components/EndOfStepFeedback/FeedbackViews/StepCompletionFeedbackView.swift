// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct StepCompletionFeedbackView: View {

    @EnvironmentObject var gameEngine: GameEngine

    var body: some View {
        ZStack {
            if gameEngine.showMotivator {
                ReinforcerView()
            } else if gameEngine.showEndAnimation {
                EndOfRoundView()
            } else {
                // Not an EmptyView() to avoid breaking the opacity animation
                Rectangle()
                    .fill(Color.clear)
            }
        }
        .background(content: {
            Group {
                if gameEngine.showBlurryBG {
                    Rectangle()
                        .fill(.regularMaterial)
                        .transition(.opacity)
                }
            }
            .animation(.default, value: gameEngine.showBlurryBG)
        })
        .edgesIgnoringSafeArea(.all)
    }
}
