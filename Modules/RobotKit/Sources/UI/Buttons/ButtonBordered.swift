// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ButtonBordered<Label: View>: View {
    // MARK: Lifecycle

    init(tint: Color? = nil, @ViewBuilder label: () -> Label, action: @escaping () -> Void) {
        self.foreground = tint
        self.border = tint
        self.action = action
        self.label = label()
    }

    init(foreground: Color, border: Color, @ViewBuilder label: () -> Label, action: @escaping () -> Void) {
        self.foreground = foreground
        self.border = border
        self.action = action
        self.label = label()
    }

    // MARK: Internal

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                label
            }
        )
        .buttonStyle(.robotControlBorderedButtonStyle(foreground: foreground, border: border))
    }

    // MARK: Private

    private let foreground: Color?
    private let border: Color?
    private let label: Label
    private let action: () -> Void
}

#Preview {
    VStack {
        ButtonBordered {
            Text("Hello, World")
        } action: {
            print("Button bordered pressed!")
        }

        ButtonBordered(tint: .orange) {
            Text("Hello, World")
        } action: {
            print("Button bordered pressed!")
        }

        ButtonBordered(foreground: .red, border: .green) {
            Text("Hello, World")
        } action: {
            print("Button bordered pressed!")
        }
    }
}
