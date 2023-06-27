// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ImageAnswerView: View {
    private let image: String
    private let status: ChoiceViewStatus

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    @ViewBuilder
    var view: some View {
        let circle = Image(image)
            .resizable()
			.aspectRatio(contentMode: .fit)
			.frame(
				width: 260,
				height: 260
			)
			.clipShape(Circle().inset(by: 2))

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

    init(image: String, status: ChoiceViewStatus = .notSelected) {
        self.image = image
        self.status = status
    }

    var body: some View {
        view
    }

}
