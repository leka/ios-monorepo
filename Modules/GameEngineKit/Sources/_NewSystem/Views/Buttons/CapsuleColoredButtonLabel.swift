// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CapsuleColoredButtonLabel: View {
    // MARK: Lifecycle

    init(_ text: String, color: Color, size: CGFloat = 300) {
        self.text = text
        self.color = color
        self.size = size
    }

    // MARK: Internal

    let text: String
    let color: Color
    let size: CGFloat

    var body: some View {
        Text(self.text)
            .font(.title3.bold())
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: self.size, height: self.size / 4.0)
            .scaledToFit()
            .background(Capsule().fill(self.color).shadow(radius: 3))
    }
}
