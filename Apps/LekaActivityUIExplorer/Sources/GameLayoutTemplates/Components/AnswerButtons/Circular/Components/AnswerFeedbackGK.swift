// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AnswerFeedbackGK: View {

    @EnvironmentObject var gameEngineGK: GameEngineGK
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var answer: Int

    var body: some View {
        if gameEngineGK.answers[answer].answerType == .right {
            Circle()
                .trim(from: 0, to: gameEngineGK.correctAnswerAnimationPercent)
                .stroke(
                    .green,
                    style: StrokeStyle(
                        lineWidth: defaults.playGridBtnTrimLineWidth,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 10))
        } else if answer == gameEngineGK.pressedAnswerIndex {
            Circle()
                .fill(.gray)
                .opacity(gameEngineGK.overlayOpacity)
        } else {
            EmptyView()
        }
    }
}
