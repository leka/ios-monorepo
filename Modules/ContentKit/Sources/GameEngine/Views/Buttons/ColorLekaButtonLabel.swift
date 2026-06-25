// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct ColorLekaButtonLabel: View {
    // MARK: Lifecycle

    init(color: Robot.Color, isPressed: Bool, size: CGFloat = 200) {
        self.color = color
        self.isPressed = isPressed
        self.size = size
    }

    // MARK: Internal

    let color: Robot.Color
    let isPressed: Bool
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: self.size, height: self.size)
                .shadow(color: self.color.screen != .white ? self.color.screen : .gray.opacity(0.6), radius: self.isPressed ? 20 : 0)
                .animation(.easeIn(duration: 0.2), value: self.isPressed)

            Circle()
                .stroke(self.color.screen != .white ? self.color.screen : .gray.opacity(0.3), lineWidth: self.size / 20.0)
                .frame(width: self.size, height: self.size)

            HStack(spacing: self.size / 6.0) {
                Circle()
                    .fill(.black)
                    .frame(width: self.size / 10.0, height: self.size / 10.0)
                Circle()
                    .fill(.black)
                    .frame(width: self.size / 10.0, height: self.size / 10.0)
            }
        }
    }
}

#Preview {
    HStack(spacing: 50) {
        ColorLekaButtonLabel(color: .red, isPressed: false)
        ColorLekaButtonLabel(color: .blue, isPressed: true)
        ColorLekaButtonLabel(color: .green, isPressed: false, size: 100)
    }
}
