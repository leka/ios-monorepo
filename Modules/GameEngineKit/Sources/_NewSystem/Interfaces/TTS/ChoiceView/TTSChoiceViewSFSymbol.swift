// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - TTSChoiceViewSFSymbol

struct TTSChoiceViewSFSymbol: View {
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
                if UIImage(systemName: self.value) != nil {
                    Image(systemName: self.value)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                } else {
                    Text("❌\nSF Symbol not found:\n\(self.value)")
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
            TTSChoiceViewSFSymbol(value: "airplane", size: 200)
            TTSChoiceViewSFSymbol(value: "paperplane", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewSFSymbol(value: "sunrise", size: 200)
            TTSChoiceViewSFSymbol(value: "sparkles", size: 200)
            TTSChoiceViewSFSymbol(value: "cloud.drizzle", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewSFSymbol(value: "cat", size: 200)
            TTSChoiceViewSFSymbol(value: "fish", size: 200)
            TTSChoiceViewSFSymbol(value: "carrot", size: 200)
            TTSChoiceViewSFSymbol(value: "not_a_real_symbol", size: 200)
        }
    }
    .background(.lkBackground)
}
