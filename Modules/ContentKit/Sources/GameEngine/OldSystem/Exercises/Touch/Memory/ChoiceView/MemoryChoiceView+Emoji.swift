// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension MemoryChoiceView {
    struct EmojiView: View {
        // MARK: Lifecycle

        init(emoji: String, size: CGFloat, state: GameplayChoiceState = .idle) {
            self.emoji = emoji
            self.size = size
            self.state = state
        }

        // MARK: Internal

        @State var degree: Double = 90.0

        // TODO(@ladislas): handle case of color white, add colored border?
        var choice: some View {
            RoundedRectangle(cornerRadius: 10)
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
                .rotation3DEffect(Angle(degrees: self.degree), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
        }

        var body: some View {
            switch self.state {
                case .idle:
                    self.choice
                        .onAppear {
                            withAnimation(.linear(duration: self.kDurationAndDelay)) {
                                self.degree = 90.0
                            }
                        }

                case .selected,
                     .rightAnswer:
                    self.choice
                        .onAppear {
                            withAnimation(.linear(duration: self.kDurationAndDelay).delay(self.kDurationAndDelay)) {
                                self.degree = 0.0
                            }
                        }

                default:
                    EmptyView()
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
        private let kDurationAndDelay: Double = 0.2
        private let nearZeroFloat: CGFloat = 0.0001
    }
}

#Preview {
    VStack(spacing: 50) {
        MemoryChoiceView.EmojiView(emoji: "🌨️", size: 200)
        MemoryChoiceView.EmojiView(emoji: "🌨️", size: 200, state: .selected)
        MemoryChoiceView.EmojiView(emoji: "☀️", size: 200, state: .rightAnswer)
        MemoryChoiceView.EmojiView(emoji: "☀️", size: 200, state: .wrongAnswer)
    }
}
