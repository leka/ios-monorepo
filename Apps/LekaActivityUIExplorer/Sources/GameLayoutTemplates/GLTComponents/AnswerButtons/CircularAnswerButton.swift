//
//  CircularAnswerButton.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import SwiftUI

struct CircularAnswerButton: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GLT_Defaults

    var answer: Int

    var body: some View {
        Button {
            gameEngine.answerHasBeenPressed(atIndex: answer)
        } label: {
            CircularAnswerContent(content: answerContent)
        }
        .buttonStyle(ActivityAnswer_ButtonStyle(isEnabled: gameEngine.currentMediaHasBeenPlayedOnce))
        .animation(.easeIn(duration: 0.3), value: gameEngine.correctAnswerAnimationPercent)
        .overlay(answerFeedback)
        .disabled(gameEngine.tapIsDisabled)
        .disabled(gameEngine.allAnswersAreDisabled)
    }

    var answerContent: String {
        guard answer < gameEngine.allAnswers.count else {
            return gameEngine.answersAreImages ? "dummy_1" : "blue"
        }
        return gameEngine.allAnswers[answer]
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
