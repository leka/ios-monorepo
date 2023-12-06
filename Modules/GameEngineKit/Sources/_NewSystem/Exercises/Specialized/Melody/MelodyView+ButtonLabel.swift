// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// TODO(@hugo/@ladislas): Make a general Button struct
extension MelodyView {

    struct ButtonLabel: View {
        let text: String
        let color: Color

        init(_ text: String, color: Color) {
            self.text = text
            self.color = color
        }

        var body: some View {
            Text(text)
                .font(.title2)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(width: 400, height: 50)
                .scaledToFit()
                .background(Capsule().fill(color).shadow(radius: 3))
        }
    }

}
