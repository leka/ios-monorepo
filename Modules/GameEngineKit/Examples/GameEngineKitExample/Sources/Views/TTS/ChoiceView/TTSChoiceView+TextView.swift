// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - TTSChoiceView.TextView

extension TTSChoiceView {
    struct TextView: View {
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
                        .badge(10)
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
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 40) {
            TTSChoiceView.TextView(value: "airplane", size: 200)
            TTSChoiceView.TextView(value: "paperplane", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceView.TextView(value: "sunrise", size: 200)
            TTSChoiceView.TextView(value: "sparkles", size: 200)
            TTSChoiceView.TextView(value: "cloud.drizzle", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceView.TextView(value: "cat", size: 200)
            TTSChoiceView.TextView(value: "fish", size: 200)
            TTSChoiceView.TextView(value: "carrot", size: 200)
            TTSChoiceView.TextView(value: "not_a_real_sumbol", size: 200)
        }
    }
    .background(.lkBackground)
}
