// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

struct ChoiceColorView: View {

    private let color: Robot.Color
    private let size: CGFloat
    private let state: GameplayChoiceState

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    init(color: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.color = Robot.Color(from: color)
        self.size = size
        self.state = state
    }

    @ViewBuilder
    var view: some View {
        let circle = Image(systemName: "circle.fill")
            .foregroundStyle(color.screen)
            .font(.system(size: size))
            .frame(
                width: size * 1.05,
                height: size * 1.05
            )

        switch state {
            case .idle:
                circle
                    .onAppear {
                        withAnimation {
                            animationPercent = 0.0
                            overlayOpacity = 0.0
                        }
                    }

            case .rightAnswer:
                circle
                    .overlay(RightAnswerFeedback(animationPercent: animationPercent))
                    .onAppear {
                        withAnimation {
                            animationPercent = 1.0
                        }
                    }

            case .wrongAnswer:
                circle
                    .overlay(WrongAnswerFeedback(overlayOpacity: overlayOpacity))
                    .onAppear {
                        withAnimation {
                            overlayOpacity = 0.8
                        }
                    }
        }
    }

    var body: some View {
        view
    }

}
