// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MemoryChoiceViewSFSymbol: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat) {
        self.sfsymbol = value
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(self.choiceBackgroundColor)
            .overlay {
                if UIImage(systemName: self.sfsymbol) != nil {
                    Image(systemName: self.sfsymbol)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                } else {
                    Text("❌\nSF Symbol not found:\n\(self.sfsymbol)")
                        .multilineTextAlignment(.center)
                        .frame(
                            width: self.size,
                            height: self.size
                        )
                        .overlay {
                            Circle()
                                .stroke(Color.red, lineWidth: 5)
                        }
                }
            }
            .foregroundStyle(.black)
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

    private let sfsymbol: String
    private let size: CGFloat
}

#Preview {
    VStack(spacing: 50) {
        MemoryChoiceViewSFSymbol(value: "🌨️", size: 200)
        MemoryChoiceViewSFSymbol(value: "☀️", size: 200)
    }
}
