// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ChoiceSFSymbolView

struct ChoiceSFSymbolView: View {
    // MARK: Lifecycle

    init(image: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.sfsymbol = image
        self.size = size
        self.state = state
    }

    // MARK: Internal

    var circle: some View {
        Circle()
            .fill(self.choiceBackgroundColor)
            .overlay {
                if UIImage(systemName: self.sfsymbol) != nil {
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
            .foregroundStyle(.black)
            .frame(
                width: self.size,
                height: self.size
            )
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

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let sfsymbol: String
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kOverLayScaleFactor: CGFloat = 1.08
}

// MARK: - l10n.ChoiceSFSymbolView

extension l10n {
    enum ChoiceSFSymbolView {
        static let sfSymbolUnknownError = LocalizedStringInterpolation("game_engine_kit.choice_sf_symbol_view.sf_symbol_unknown_error",
                                                                       bundle: GameEngineKitResources.bundle,
                                                                       value: "❌\nSF Symbol not found:\n%1$@",
                                                                       comment: "ChoiceSFSymbolView SF symbol unknown error label")
    }
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 40) {
            ChoiceSFSymbolView(image: "airplane", size: 200)
            ChoiceSFSymbolView(image: "paperplane", size: 200)
        }

        HStack(spacing: 40) {
            ChoiceSFSymbolView(image: "sunrise", size: 200)
            ChoiceSFSymbolView(image: "sparkles", size: 200, state: .rightAnswer)
            ChoiceSFSymbolView(image: "cloud.drizzle", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 40) {
            ChoiceSFSymbolView(image: "cat", size: 200)
            ChoiceSFSymbolView(image: "fish", size: 200)
            ChoiceSFSymbolView(image: "carrot", size: 200)
            ChoiceSFSymbolView(image: "not_a_real_sumbol", size: 200)
        }
    }
    .background(.lkBackground)
}
