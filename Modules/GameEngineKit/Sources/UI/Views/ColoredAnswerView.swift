// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColoredAnswerView: View {
    private let color: Color
    private let size: CGFloat
    private let status: ChoiceState

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    @ViewBuilder
    var view: some View {
        let circle = Circle()
            .foregroundColor(color)
            .frame(
                width: size,
                height: size
            )

        switch status {
            case .notSelected:
                circle
                    .onAppear {
                        withAnimation {
                            animationPercent = 0.0
                            overlayOpacity = 0.0
                        }
                    }
            case .selected:
                circle
                    .overlay(.black)
            case .playingRightAnimation:
                circle
                    .overlay(RightAnswerFeedback(animationPercent: animationPercent))
                    .onAppear {
                        withAnimation {
                            animationPercent = 1.0
                        }
                    }
            case .playingWrongAnimation:
                circle
                    .overlay(WrongAnswerFeedback(overlayOpacity: overlayOpacity))
                    .onAppear {
                        withAnimation {
                            overlayOpacity = 0.8
                        }
                    }
        }
    }

    init(color: String, size: CGFloat, status: ChoiceState = .notSelected) {
        self.color = ColoredAnswerView.stringToColor(from: color)
        self.size = size
        self.status = status
    }

    static func stringToColor(from: String) -> Color {
        switch from {
            case "red": return .red
            case "pink": return .pink
            case "purple": return .purple
            case "blue": return .blue
            case "green": return .green
            case "yellow": return .yellow
            default: return .blue
        }
    }

    var body: some View {
        view
    }
}
