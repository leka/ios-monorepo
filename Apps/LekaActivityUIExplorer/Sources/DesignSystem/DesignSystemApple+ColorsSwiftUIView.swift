// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Color {

    // swiftlint:disable:next identifier_name
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.displayP3, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension DesignSystemApple {

    struct ColorsSwiftUIView: View {

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Primary, secondary, accent")
                        .font(.title2)
                    ColorSwiftUIView(color: .primary)
                    ColorSwiftUIView(color: .secondary)
                    ColorSwiftUIView(color: .accentColor)

                    Text("Black, gray, white")
                        .font(.title2)
                    ColorSwiftUIView(color: .black)
                    ColorSwiftUIView(color: .gray)
                    ColorSwiftUIView(color: .white)

                    Text("Rainbow")
                        .font(.title2)
                    ColorSwiftUIView(color: .red)
                    ColorSwiftUIView(color: .orange)
                    ColorSwiftUIView(color: .yellow)
                    ColorSwiftUIView(color: .green)
                    ColorSwiftUIView(color: .mint)
                    ColorSwiftUIView(color: .teal)
                    ColorSwiftUIView(color: .cyan)
                    ColorSwiftUIView(color: .blue)
                    ColorSwiftUIView(color: .indigo)
                    ColorSwiftUIView(color: .purple)
                    ColorSwiftUIView(color: .pink)
                    ColorSwiftUIView(color: .brown)
                }
            }
            .navigationTitle("SwiftUI colors")
        }
    }
}

#Preview {
    DesignSystemApple.ColorsSwiftUIView()
}
