// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TextAnswerView: View {
    private let text: String
    private let status: ChoiceState

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    @ViewBuilder
    var view: some View {
		let circle = ZStack {
			Circle()
				.fill(.gray.opacity(0.8))
				.frame(
					width: 260,
					height: 260
				)

			Text(text.uppercased())
				.font(.title.bold())
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

    init(text: String, status: ChoiceState = .notSelected) {
        self.text = text
        self.status = status
    }

    var body: some View {
        view
    }
}
