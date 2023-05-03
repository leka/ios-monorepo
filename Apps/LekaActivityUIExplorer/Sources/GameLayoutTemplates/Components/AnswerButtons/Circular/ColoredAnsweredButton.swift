// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColoredAnswerButton: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var colors: [Color] = [.green, .purple, .red, .yellow, .blue]

    var answer: Int

    var body: some View {
        Button {
            gameEngine.answerHasBeenPressed(atIndex: answer)
        } label: {
            Circle()
                .foregroundColor(colors[answer])
                .frame(width: defaults.playGridBtnSize, height: defaults.playGridBtnSize, alignment: .center)
        }
        .buttonStyle(ActivityAnswer_ButtonStyle(isEnabled: gameEngine.currentMediaHasBeenPlayedOnce))
        .animation(.easeIn(duration: 0.3), value: gameEngine.correctAnswerAnimationPercent)
        .overlay(answerFeedback)
        .disabled(gameEngine.tapIsDisabled)
        .disabled(gameEngine.allAnswersAreDisabled)
    }

    @ViewBuilder
    private var answerFeedback: some View {
        if answer == gameEngine.correctAnswerIndex {
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
