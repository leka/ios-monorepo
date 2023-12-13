// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SwiftUI

struct ChoiceSFSymbolView: View {
    // MARK: Lifecycle

    init(image: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.sfsymbol = image
        self.size = size
        self.state = state
    }

    // MARK: Internal

    @ViewBuilder
    var circle: some View {
        Circle()
            .fill(.white)
            .overlay {
                if let uiImage = UIImage(systemName: self.sfsymbol) {
                    Image(systemName: self.sfsymbol)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                } else {
                    Text("❌\nSF Symbol not found:\n\(self.sfsymbol)")
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
            .frame(
                width: self.size,
                height: self.size
            )
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

    private let sfsymbol: String
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kOverLayScaleFactor: CGFloat = 1.08

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 50) {
            ChoiceSFSymbolView(image: "airplane", size: 200)
            ChoiceSFSymbolView(image: "paperplane", size: 200)
        }

        HStack(spacing: 50) {
            ChoiceSFSymbolView(image: "sunrise", size: 200)
            ChoiceSFSymbolView(image: "sparkles", size: 200, state: .rightAnswer)
            ChoiceSFSymbolView(image: "cloud.drizzle", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 0) {
            ChoiceSFSymbolView(image: "cat", size: 200)
            ChoiceSFSymbolView(image: "fish", size: 200)
            ChoiceSFSymbolView(image: "carrot", size: 200)
            ChoiceSFSymbolView(image: "not_a_real_sumbol", size: 200)
        }
    }
}
