// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct RobotControlActionButton: View {

    private let title: String
    private let image: String
    private let tint: Color
    private let action: () -> Void

    public init(title: String, image: String, tint: Color, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.tint = tint
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
            Text(title)
        }
        .buttonStyle(.robotControlBorderedButtonStyle(foreground: tint, border: tint))
    }
}

#Preview {
    VStack {
        RobotControlActionButton(title: "Say hello", image: "ellipsis.message", tint: .teal) {
            print("Hello!")
        }
    }
}
