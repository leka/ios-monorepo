// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DanceFreezeStageModeButtonStyle

struct DanceFreezeStageModeButtonStyle: View {
    // MARK: Lifecycle

    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }

    // MARK: Internal

    let text: String
    let color: Color

    var body: some View {
        Text(self.text)
            .font(.body)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: 220, height: 50)
            .scaledToFit()
            .background(RoundedRectangle(cornerRadius: 10).fill(self.color).shadow(radius: 3))
    }
}

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
        DanceFreezeStageModeButtonStyle(
            "Stage Mode",
            color: .blue
        )
        DanceFreezeMotionModeButtonStyle(
            image: Image(systemName: "wrench"),
            color: .blue
        )
    }
}
