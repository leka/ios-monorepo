// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SwiftUI

public struct ChoiceImageView: View {
    // MARK: Lifecycle

    public init(image: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.image = image
        self.size = size
        self.state = state
    }

    // MARK: Public

    public var body: some View {
        switch self.state {
            case .idle:
                self.circle
                    .onAppear {
                        withAnimation {
                            self.animationPercent = 0.0
                            self.overlayOpacity = 0.0
                        }
                    }

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

    // MARK: Internal

    @ViewBuilder
    var circle: some View {
        // TODO: (@ladislas) fix use of module as it would not work in LekaApp
        if let uiImage = UIImage(named: image, in: .module, with: nil) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: self.size,
                    height: self.size
                )
                .clipShape(Circle())
        } else {
            Text("❌\nImage not found:\n\(self.image)")
                .multilineTextAlignment(.center)
                .frame(
                    width: self.size,
                    height: self.size
                )
                .overlay {
                    Circle()
                        .stroke(Color.red, lineWidth: 5)
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
            ChoiceImageView(image: "image-placeholder-png-boy_sleeping", size: 200)
            ChoiceImageView(image: "image-placeholder-missing", size: 200)
        }

        HStack(spacing: 50) {
            ChoiceImageView(image: "image-placeholder-png-boy_sleeping", size: 200)
            ChoiceImageView(image: "image-placeholder-png-boy_sleeping", size: 200, state: .rightAnswer)
            ChoiceImageView(image: "image-placeholder-png-boy_sleeping", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 0) {
            ChoiceImageView(image: "image-placeholder-png-boy_sleeping", size: 200)
            ChoiceColorView(color: "blue", size: 200)

            ChoiceImageView(image: "image-placeholder-png-boy_sleeping", size: 200, state: .rightAnswer)
            ChoiceColorView(color: "blue", size: 200, state: .rightAnswer)
        }
    }
}
