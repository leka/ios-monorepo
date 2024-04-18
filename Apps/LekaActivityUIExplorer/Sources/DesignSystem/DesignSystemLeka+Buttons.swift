// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension DesignSystemLeka {
    struct ButtonsView: View {
        let colors: [Color] = [
            Color(hex: 0xAFCE36),
            Color(hex: 0x0A579B),
            Color(hex: 0xCFEBFC),
        ]

        var body: some View {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(self.colors, id: \.self) { color in
                        VStack(alignment: .leading) {
                            Button("automatic tint \(color.description)") {}
                                .buttonStyle(.automatic)
                                .tint(color)

                            Button("bordered tint \(color.description)") {}
                                .buttonStyle(.bordered)
                                .tint(color)

                            Button("borderedProminent tint \(color.description)") {}
                                .buttonStyle(.borderedProminent)
                                .tint(color)

                            Button("borderless tint \(color.description)") {}
                                .buttonStyle(.borderless)
                                .tint(color)

                            Button("custom bordered \(color.description)") {}
                                .buttonStyle(.robotControlBorderedButtonStyle(foreground: color, border: color))
                        }
                    }
                }
            }
            .navigationTitle("Leka Buttons")
        }
    }
}

#Preview {
    DesignSystemApple.ButtonsView()
}
