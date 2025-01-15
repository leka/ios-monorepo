// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SVGView
import SwiftUI

// MARK: - TTSChoiceViewColor

struct TTSChoiceViewColor: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat, background: Color? = nil) {
        self.color = Robot.Color(from: value)
        self.size = size
        self.background = background ?? self.choiceBackgroundColor
    }

    // MARK: Internal

    var body: some View {
        self.color.screen
            .frame(
                width: self.size,
                height: self.size
            )
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    // MARK: Private

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let color: Robot.Color
    private let size: CGFloat
    private let background: Color
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 40) {
            TTSChoiceViewColor(value: "red", size: 200)
            TTSChoiceViewColor(value: "blue", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewColor(value: "green", size: 200)
            TTSChoiceViewColor(value: "red", size: 200)
            TTSChoiceViewColor(value: "yellow", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewColor(value: "cyan", size: 200)
            TTSChoiceViewColor(value: "yellow", size: 200)
            TTSChoiceViewColor(value: "green", size: 200)
            TTSChoiceViewColor(value: "red", size: 200)
        }
    }
    .background(.lkBackground)
}
