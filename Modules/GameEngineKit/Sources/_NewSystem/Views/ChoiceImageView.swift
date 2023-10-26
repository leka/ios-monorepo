// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

//import Combine
import ContentKit
import RobotKit
import SwiftUI

struct ChoiceImageView: View {

    private let image: String
    private let size: CGFloat
    private let state: GameplayChoiceState

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    init(image: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.image = image
        self.size = size
        self.state = state
    }

    @ViewBuilder
    var view: some View {
        let circle = Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: size,
                height: size
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
