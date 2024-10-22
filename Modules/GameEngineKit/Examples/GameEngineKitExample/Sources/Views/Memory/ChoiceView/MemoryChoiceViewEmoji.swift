// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

struct MemoryChoiceViewEmoji: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat) {
        self.emoji = value
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(self.choiceBackgroundColor)
            .overlay {
                if self.emoji.count == 1, self.emoji.containsOnlyEmojis() {
                    Text(self.emoji)
                        .font(.system(size: self.size / 2))
                } else {
                    Text("\(self.emoji) not found")
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

    private let emoji: String
    private let size: CGFloat
}

#Preview {
    VStack(spacing: 50) {
        MemoryChoiceViewEmoji(value: "🌨️", size: 200)
        MemoryChoiceViewEmoji(value: "☀️", size: 200)
    }
}
