// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColoredAnswerButton: View {

    @EnvironmentObject var gameEngine: GameEngine
    @ObservedObject var templateDefaults: BaseDefaults

    var answer: Int

    var body: some View {
        Button {
            gameEngine.answerHasBeenPressed(atIndex: answer)
        } label: {
            Circle()
                .foregroundColor(gameEngine.stringToColor(from: gameEngine.allAnswers[safeAnswer]))
        }
        .buttonStyle(ActivityAnswer_ButtonStyle(isEnabled: gameEngine.currentMediaHasBeenPlayedOnce))
        .animation(.easeIn(duration: 0.3), value: gameEngine.correctAnswerAnimationPercent)
        .overlay(AnswerFeedback(answer: answer))
        .disabled(gameEngine.tapIsDisabled)
        .disabled(gameEngine.allAnswersAreDisabled)
        .frame(
            width: templateDefaults.customAnswerSize,
            height: templateDefaults.customAnswerSize
        )
    }

    var safeAnswer: Int {
        guard answer < gameEngine.allAnswers.count else {
            return 0
        }
        return answer
    }
}
