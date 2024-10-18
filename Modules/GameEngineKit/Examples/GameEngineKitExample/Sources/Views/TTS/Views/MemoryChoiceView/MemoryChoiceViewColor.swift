// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

struct MemoryChoiceViewColor: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat) {
        self.color = Robot.Color(from: value)
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        self.color.screen
            .frame(
                width: self.size,
                height: self.size
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    // MARK: Private

    private let color: Robot.Color
    private let size: CGFloat
}

#Preview {
    VStack(spacing: 50) {
        MemoryChoiceViewColor(value: "red", size: 200)
        MemoryChoiceViewColor(value: "blue", size: 200)
        MemoryChoiceViewColor(value: "white", size: 200)
    }
}
