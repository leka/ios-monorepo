// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AnswerFeedback: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var answer: Int

    var body: some View {
        if gameEngine.correctAnswersIndices[0].contains(answer) {
            Circle()
                .trim(from: 0, to: gameEngine.correctAnswerAnimationPercent)
                .stroke(
                    .green,
                    style: StrokeStyle(
                        lineWidth: defaults.playGridBtnTrimLineWidth,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 10))
        } else if answer == gameEngine.pressedAnswerIndex {
            Circle()
                .fill(.gray)
                .opacity(gameEngine.overlayOpacity)
        } else {
            EmptyView()
        }
    }
}
