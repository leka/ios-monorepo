// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColoredAnswerGKButton: View {

    @EnvironmentObject var gameEngineGK: GameEngineGK
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @ObservedObject var templateDefaults: BaseDefaults

    var index: Int

    var body: some View {
        Button {
            gameEngineGK.answerHasBeenPressed(atIndex: index)
        } label: {
            Circle()
                .foregroundColor(gameEngineGK.answers[index].color)
        }
        .buttonStyle(ActivityAnswer_ButtonStyle(isEnabled: gameEngineGK.currentMediaHasBeenPlayedOnce))
        .animation(.easeIn(duration: 0.3), value: gameEngineGK.correctAnswerAnimationPercent)
        .overlay(AnswerFeedbackGK(answer: index))
        .disabled(gameEngineGK.tapIsDisabled)
        .disabled(gameEngineGK.allAnswersAreDisabled)
        .frame(
            width: templateDefaults.customAnswerSize,
            height: templateDefaults.customAnswerSize
        )
    }
}
