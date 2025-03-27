// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ExerciseNavigationButtonLabel: View {
    let text: String
    let color: Color

    var body: some View {
        Text(self.text)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: 150, height: 100)
            .padding()
            .background(Capsule().fill(self.color).shadow(radius: 1))
    }
}

#Preview {
    ExerciseNavigationButtonLabel(text: "Exercise 1", color: .red)
}
