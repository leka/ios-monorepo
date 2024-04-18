// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension HideAndSeekView {
    struct ButtonLabel: View {
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
                .frame(width: 400, height: 50)
                .scaledToFit()
                .background(Capsule().fill(self.color).shadow(radius: 3))
        }
    }
}
