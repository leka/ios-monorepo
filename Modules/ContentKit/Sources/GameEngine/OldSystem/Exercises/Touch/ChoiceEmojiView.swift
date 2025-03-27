// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ChoiceEmojiView

struct ChoiceEmojiView: View {
    // MARK: Lifecycle

    init(emoji: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.emoji = emoji
        self.size = size
        self.state = state
    }

    // MARK: Internal

    var circle: some View {
        Circle()
            .fill(self.choiceBackgroundColor)
            .overlay {
                if self.emoji.count == 1, self.emoji.containsOnlyEmojis() {
                    Text(self.emoji)
                        .font(.system(size: self.size / 2))
                } else {
                    Text(l10n.ChoiceEmojiView.emojiError(self.emoji))
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

    private let emoji: String
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kOverLayScaleFactor: CGFloat = 1.08
}

// MARK: - l10n.ChoiceEmojiView

extension l10n {
    enum ChoiceEmojiView {
        static let emojiError = LocalizedStringInterpolation("game_engine_kit.choice_emoji_view.emoji_error",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "❌\nText is not emoji:\n%1$@",
                                                             comment: "ChoiceEmojiView emoji error ")
    }
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 50) {
            ChoiceEmojiView(emoji: "🍉", size: 200)
            ChoiceEmojiView(emoji: "🍏", size: 200)
        }

        HStack(spacing: 40) {
            ChoiceEmojiView(emoji: "🌨️", size: 200)
            ChoiceEmojiView(emoji: "🌧️", size: 200, state: .rightAnswer)
            ChoiceEmojiView(emoji: "☀️", size: 200, state: .wrongAnswer)
        }

        HStack(spacing: 40) {
            ChoiceEmojiView(emoji: "🐱", size: 200)
            ChoiceEmojiView(emoji: "🐶", size: 200)
            ChoiceEmojiView(emoji: "🐹🐹", size: 200)
            ChoiceEmojiView(emoji: "not_emoji", size: 200)
        }
    }
}
