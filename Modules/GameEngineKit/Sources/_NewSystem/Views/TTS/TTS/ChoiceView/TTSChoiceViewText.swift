// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - TTSChoiceViewText

struct TTSChoiceViewText: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat) {
        self.value = value
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        Circle()
            .fill(self.choiceBackgroundColor)
            .frame(
                width: self.size,
                height: self.size
            )
            .overlay {
                Text(self.value)
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundStyle(.black)
            }
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
            TTSChoiceViewText(value: "airplane", size: 200)
            TTSChoiceViewText(value: "paperplane", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewText(value: "sunrise", size: 200)
            TTSChoiceViewText(value: "sparkles", size: 200)
            TTSChoiceViewText(value: "cloud.drizzle", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewText(value: "cat", size: 200)
            TTSChoiceViewText(value: "fish", size: 200)
            TTSChoiceViewText(value: "carrot", size: 200)
            TTSChoiceViewText(value: "not_a_real_sumbol", size: 200)
        }
    }
    .background(.lkBackground)
}
