// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct TextAnswerView: View {
    private let text: String
    private let size: CGFloat
    private let status: ChoiceState

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    @ViewBuilder
    var view: some View {
        let circle = ZStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .font(.system(size: size))
                .frame(
                    width: size * 1.05,
                    height: size * 1.05
                )

            Text(text.uppercased())
                .font(.largeTitle.uppercaseSmallCaps())
                .foregroundColor(.white)
        }

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

    init(text: String, size: CGFloat, status: ChoiceState = .notSelected) {
        self.text = text
        self.size = size
        self.status = status
    }

    var body: some View {
        view
    }
}

struct TextAnswerView_Previews:
    PreviewProvider
{
    static var previews: some View {
        TextAnswerView(text: "Hello", size: 500, status: .playingRightAnimation)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
