// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension DesignSystemApple {
    struct ButtonsView: View {
        let colors: [Color] = [
            .primary,
            .secondary,
            .accentColor,
            .red,
            .orange,
            .yellow,
            .green,
            .mint,
            .teal,
            .cyan,
            .blue,
            .indigo,
            .purple,
            .pink,
            .brown,
        ]

        var body: some View {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading) {
                        Button("automatic default") {}
                            .buttonStyle(.automatic)

                        Button("bordered default") {}
                            .buttonStyle(.bordered)

                        Button("borderedProminent default") {}
                            .buttonStyle(.borderedProminent)

                        Button("borderless default") {}
                            .buttonStyle(.borderless)
                        Button("custom bordered default") {}
                            .buttonStyle(.robotControlBorderedButtonStyle())
                    }

                    ForEach(colors, id: \.self) { color in
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
            .navigationTitle("Apple Buttons")
        }
    }
}

#Preview {
    DesignSystemApple.ButtonsView()
}
