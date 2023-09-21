// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ColoredAnswerView: View {
    private let color: Color
    private let size: CGFloat
    private let status: ChoiceState

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    @ViewBuilder
    var view: some View {
        let circle = Image(systemName: "circle.fill")
            .foregroundStyle(color)
            .font(.system(size: size))
            .frame(
                width: size * 1.05,
                height: size * 1.05
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
            case "red": return DesignKitAsset.Colors.lekaActivityRed.swiftUIColor
            case "orange": return DesignKitAsset.Colors.lekaActivityOrange.swiftUIColor
            case "yellow": return DesignKitAsset.Colors.lekaActivityYellow.swiftUIColor
            case "green": return DesignKitAsset.Colors.lekaActivityGreen.swiftUIColor
            case "blue": return DesignKitAsset.Colors.lekaActivityBlue.swiftUIColor
            case "pink": return DesignKitAsset.Colors.lekaActivityPink.swiftUIColor
            case "purple": return DesignKitAsset.Colors.lekaActivityPurple.swiftUIColor
            default: return .black
        }
    }

    var body: some View {
        view
    }
}

struct ColoredAnswerView_Previews:
    PreviewProvider
{
    static var previews: some View {
        ColoredAnswerView(color: "red", size: 500, status: .playingRightAnimation)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
