// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DanceFreezeMotionModeButtonStyle

struct DanceFreezeMotionModeButtonStyle: View {
    let image: Image
    let color: Color

    var body: some View {
        self.image
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(self.color)
            .scaledToFit()
            .frame(maxWidth: 100)
    }
}

#Preview {
    HStack(spacing: 100) {
        DanceFreezeMotionModeButtonStyle(
            image: Image(systemName: "wrench"),
            color: .blue
        )
        DanceFreezeMotionModeButtonStyle(
            image: Image(systemName: "book"),
            color: .green
        )
    }
}
