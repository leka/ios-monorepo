// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - TTSChoiceViewEmoji

struct TTSChoiceViewEmoji: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat) {
        self.value = value
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        Circle()
            .fill(self.choiceBackgroundColor)
            .overlay {
                if self.value.count == 1, self.value.containsOnlyEmojis() {
                    Text(self.value)
                        .font(.system(size: self.size / 2))
                } else {
                    Text(l10n.ChoiceEmojiView.emojiError(self.value))
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

    // MARK: Private

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let value: String
    private let size: CGFloat
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 40) {
            TTSChoiceViewEmoji(value: "🍉", size: 200)
            TTSChoiceViewEmoji(value: "🍏", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewEmoji(value: "🌨️", size: 200)
            TTSChoiceViewEmoji(value: "🌧️", size: 200)
            TTSChoiceViewEmoji(value: "☀️", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewEmoji(value: "🐱", size: 200)
            TTSChoiceViewEmoji(value: "🐶", size: 200)
            TTSChoiceViewEmoji(value: "🐹🐹", size: 200)
            TTSChoiceViewEmoji(value: "not_emoji", size: 200)
        }
    }
    .background(.lkBackground)
}
