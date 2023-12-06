// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ButtonFilled<Label: View>: View {

    private let foreground: Color
    private let background: Color
    private let label: Label
    private let action: () -> Void

    init(foreground: Color, background: Color, @ViewBuilder label: () -> Label, action: @escaping () -> Void) {
        self.foreground = foreground
        self.background = background
        self.action = action
        self.label = label()
    }

    init(tint: Color? = nil, @ViewBuilder label: () -> Label, action: @escaping () -> Void) {
        self.foreground = .white
        self.background = tint ?? .accentColor
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                label
            }
        )
        .buttonStyle(.robotControlPlainButtonStyle(foreground: foreground, background: background))
    }
}

#Preview {
    VStack {
        ButtonFilled {
            Image(systemName: "hand.wave.fill")
            Text("Hello, World")
        } action: {
            print("Button filled pressed!")
        }

        ButtonFilled(tint: .orange) {
            Text("Hello, World")
        } action: {
            print("Button filled pressed!")
        }

        ButtonFilled(foreground: .red, background: .yellow) {
            Text("Hello, World")
        } action: {
            print("Button filled pressed!")
        }
    }
}
