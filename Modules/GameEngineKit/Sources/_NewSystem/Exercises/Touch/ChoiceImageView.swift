// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SwiftUI

struct ChoiceImageView: View {
    // MARK: Lifecycle

    init(image: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.image = image
        self.size = size
        self.state = state
    }

    // MARK: Internal

    @ViewBuilder
    var circle: some View {
        if let uiImage = UIImage(named: image) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: size,
                    height: size
                )
                .clipShape(Circle())
        } else {
            Text("❌\nImage not found:\n\(image)")
                .multilineTextAlignment(.center)
                .frame(
                    width: size,
                    height: size
                )
                .overlay {
                    Circle()
                        .stroke(Color.red, lineWidth: 5)
                }
        }
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

    // MARK: Private

    private let image: String
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kOverLayScaleFactor: CGFloat = 1.08

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 50) {
            ChoiceImageView(image: "image-placeholder-animals", size: 200)
            ChoiceImageView(image: "image-placeholder-missing", size: 200)
        }

        HStack(spacing: 50) {
            ChoiceImageView(image: "image-placeholder-animals", size: 200)
            ChoiceImageView(image: "image-placeholder-animals", size: 200, state: .rightAnswer)
            ChoiceImageView(image: "image-placeholder-animals", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 0) {
            ChoiceImageView(image: "image-placeholder-animals", size: 200)
            ChoiceColorView(color: "blue", size: 200)

            ChoiceImageView(image: "image-placeholder-animals", size: 200, state: .rightAnswer)
            ChoiceColorView(color: "blue", size: 200, state: .rightAnswer)
        }
    }
}
