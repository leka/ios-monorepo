// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

struct ChoiceColorView: View {
    // MARK: Lifecycle

    init(color: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.color = Robot.Color(from: color)
        self.size = size
        self.state = state
    }

    // MARK: Internal

    // TODO(@ladislas): handle case of color white, add colored border?
    var circle: some View {
        self.color.screen
            .frame(
                width: self.size,
                height: self.size
            )
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    var body: some View {
        switch self.state {
            case .idle:
                self.circle
                    .onAppear {
                        withAnimation {
                            self.animationPercent = 0.0
                            self.overlayOpacity = 0.0
                        }
                    }

            // TODO: (@team) Update overlay and animation when this will be used in TTS
            case .selected:
                self.circle

            case .rightAnswer:
                self.circle
                    .overlay {
                        RightAnswerFeedback(animationPercent: self.animationPercent)
                            .frame(
                                width: self.size * self.kOverLayScaleFactor,
                                height: self.size * self.kOverLayScaleFactor
                            )
                    }
                    .onAppear {
                        withAnimation {
                            self.animationPercent = 1.0
                        }
                    }

            case .wrongAnswer:
                self.circle
                    .overlay {
                        WrongAnswerFeedback(overlayOpacity: self.overlayOpacity)
                            .frame(
                                width: self.size * self.kOverLayScaleFactor,
                                height: self.size * self.kOverLayScaleFactor
                            )
                    }
                    .onAppear {
                        withAnimation {
                            self.overlayOpacity = 0.8
                        }
                    }
        }
    }

    // MARK: Private

    private let color: Robot.Color
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kOverLayScaleFactor: CGFloat = 1.08

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero
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
