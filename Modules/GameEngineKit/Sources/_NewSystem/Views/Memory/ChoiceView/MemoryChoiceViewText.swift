// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct NewMemoryChoiceViewText: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat) {
        self.text = value
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(self.choiceBackgroundColor)
            .overlay {
                Text(self.text)
                    .font(.largeTitle)
            }
            .frame(
                width: self.size,
                height: self.size
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    // MARK: Private

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let text: String
    private let size: CGFloat
}

#Preview {
    VStack(spacing: 50) {
        NewMemoryChoiceViewText(value: "Maison", size: 200)
        NewMemoryChoiceViewText(value: "Chien", size: 200)
    }
}
