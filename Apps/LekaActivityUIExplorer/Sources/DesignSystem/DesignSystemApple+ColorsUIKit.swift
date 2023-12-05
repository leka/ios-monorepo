// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension UIColor {

    // swiftlint:disable:next identifier_name
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format: "#%06x", rgb)
    }

}

extension DesignSystemApple {

    struct ColorsUIKitView: View {

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Adaptable colors")
                        .font(.title2)
                    ColorView(color: .systemRed)
                    ColorView(color: .systemOrange)
                    ColorView(color: .systemYellow)
                    ColorView(color: .systemGreen)
                    ColorView(color: .systemMint)
                    ColorView(color: .systemTeal)
                    ColorView(color: .systemCyan)
                    ColorView(color: .systemBlue)
                    ColorView(color: .systemIndigo)
                    ColorView(color: .systemPurple)
                    ColorView(color: .systemPink)
                    ColorView(color: .systemBrown)

                    Text("Adaptable gray colors")
                        .font(.title2)
                    ColorView(color: .systemGray)
                    ColorView(color: .systemGray2)
                    ColorView(color: .systemGray3)
                    ColorView(color: .systemGray4)
                    ColorView(color: .systemGray5)
                    ColorView(color: .systemGray6)

                    Text("Fixed colors")
                        .font(.title2)
                    ColorView(color: .black)
                    ColorView(color: .darkGray)
                    ColorView(color: .gray)
                    ColorView(color: .lightGray)
                    ColorView(color: .white)

                    ColorView(color: .red)
                    ColorView(color: .orange)
                    ColorView(color: .yellow)
                    ColorView(color: .green)
                    ColorView(color: .cyan)
                    ColorView(color: .blue)
                    ColorView(color: .purple)
                    ColorView(color: .magenta)
                    ColorView(color: .brown)
                }
            }
            .navigationTitle("UIKit Colors")
        }

    }

    struct ColorView: View {

        @Environment(\.self) var environment

        let color: UIColor

        init(color: UIColor) {
            self.color = color
        }

        var body: some View {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading) {
                    Text("\(color.accessibilityName): \(color.hex.uppercased())")
                    Text("The quick brown fox jumps over the lazy dog")

                }
            }
            .foregroundColor(Color(uiColor: color))
        }

    }

}

#Preview {
    DesignSystemApple.ColorsUIKitView()
}
