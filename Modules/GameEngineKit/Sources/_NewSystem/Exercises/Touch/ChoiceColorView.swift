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
    private let kOverLayScaleFactor: CGFloat = 1.08

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    init(color: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.color = Robot.Color(from: color)
        self.size = size
        self.state = state
    }

    // TODO(@ladislas): handle case of color white, add colored border?
    var circle: some View {
        color.screen
            .frame(
                width: size,
                height: size
            )
            .clipShape(Circle())
    }

    var body: some View {
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
                    .overlay {
                        RightAnswerFeedback(animationPercent: animationPercent)
                            .frame(
                                width: size * kOverLayScaleFactor,
                                height: size * kOverLayScaleFactor
                            )
                    }
                    .onAppear {
                        withAnimation {
                            animationPercent = 1.0
                        }
                    }

            case .wrongAnswer:
                circle
                    .overlay {
                        WrongAnswerFeedback(overlayOpacity: overlayOpacity)
                            .frame(
                                width: size * kOverLayScaleFactor,
                                height: size * kOverLayScaleFactor
                            )
                    }
                    .onAppear {
                        withAnimation {
                            overlayOpacity = 0.8
                        }
                    }
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        HStack(spacing: 50) {
            ChoiceColorView(color: "red", size: 200)
            ChoiceColorView(color: "red", size: 200, state: .rightAnswer)
            ChoiceColorView(color: "red", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 50) {
            ChoiceColorView(color: "green", size: 200)
            ChoiceColorView(color: "green", size: 200, state: .rightAnswer)
            ChoiceColorView(color: "green", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 50) {
            ChoiceColorView(color: "blue", size: 200)
            ChoiceColorView(color: "blue", size: 200, state: .rightAnswer)
            ChoiceColorView(color: "blue", size: 200, state: .wrongAnswer)
        }
    }
}
