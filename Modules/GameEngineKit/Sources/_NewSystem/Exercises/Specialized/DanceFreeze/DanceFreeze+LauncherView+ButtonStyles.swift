// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension DanceFreeze.LauncherView {

    struct StageModeButtonStyle: View {
        let text: String
        let color: Color

        init(_ text: String, color: Color) {
            self.text = text
            self.color = color
        }

        var body: some View {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(width: 220, height: 50)
                .scaledToFit()
                .background(RoundedRectangle(cornerRadius: 10).fill(color).shadow(radius: 3))
        }
    }

    struct MotionModeButtonStyle: View {
        let image: Image
        let color: Color

        var body: some View {
            image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(color)
                .scaledToFit()
        }
    }
}
