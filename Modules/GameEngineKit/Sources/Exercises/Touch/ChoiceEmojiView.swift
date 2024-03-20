// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import RobotKit
import SwiftUI

// TODO: (@ladislas) Move to UtilsKit
extension String {
    func containsEmoji() -> Bool {
        contains { $0.isEmoji }
    }

    func containsOnlyEmojis() -> Bool {
        count > 0 && !contains { !$0.isEmoji }
    }
}

extension Character {
    // An emoji can either be a 2 byte unicode character or a normal UTF8 character with an emoji modifier
    // appended as is the case with 3️⃣. 0x203C is the first instance of UTF16 emoji that requires no modifier.
    // `isEmoji` will evaluate to true for any character that can be turned into an emoji by adding a modifier
    // such as the digit "3". To avoid this we confirm that any character below 0x203C has an emoji modifier attached
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value >= 0x203C || unicodeScalars.count > 1)
    }
}

// MARK: - ChoiceEmojiView

struct ChoiceEmojiView: View {
    // MARK: Lifecycle

    init(emoji: String, size: CGFloat, state: GameplayChoiceState = .idle) {
        self.emoji = emoji
        self.size = size
        self.state = state
    }

    // MARK: Internal

    @ViewBuilder
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

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let emoji: String
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kOverLayScaleFactor: CGFloat = 1.08

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero
}

// MARK: - l10n.ChoiceEmojiView

extension l10n {
    enum ChoiceEmojiView {
        static let emojiError = LocalizedStringInterpolation("game_engine_kit.choice_emoji_view.emoji_error",
                                                             bundle: GameEngineKitResources.bundle,
                                                             value: "❌\nText is not emoji:\n%s",
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
