// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - TTSChoiceView

struct TTSChoiceView: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat, isTappable: Bool = true) {
        self.value = value
        self.type = type
        self.size = size
        self.isTappable = isTappable
    }

    // MARK: Internal

    var body: some View {
        Group {
            switch self.type {
                case .sfsymbol:
                    TTSChoiceViewSFSymbol(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .text:
                    TTSChoiceViewText(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)
                case .emoji:
                    TTSChoiceViewEmoji(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .image:
                    TTSChoiceViewImage(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)
                case .color:
                    TTSChoiceViewColor(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)
            }
        }
        .contentShape(Circle())
    }

    // MARK: Private

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private var isTappable = true
}

#Preview {
    VStack(alignment: .center, spacing: 40) {
        HStack(spacing: 40) {
            TTSChoiceView(value: "star", type: .sfsymbol, size: 200)
            TTSChoiceView(value: "House", type: .text, size: 200)
            TTSChoiceView(value: "🚴", type: .emoji, size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceView(value: "emotion_picto_joy_leka", type: .image, size: 200)
            TTSChoiceView(value: "red", type: .color, size: 200)
        }
    }
}
