// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotControlStopButton: View {
    var body: some View {
        Button {
            print("STOP ROBOT")
            // TODO(@ladislas): Add command
        } label: {
            Image(systemName: "exclamationmark.octagon.fill")
            Text("STOP")
                .bold()
        }
        .buttonStyle(.robotControlPlainButtonStyle(foreground: .white, background: .red))
    }
}

struct RobotControlActionButton: View {

    private let title: String
    private let image: String
    private let tint: Color
    private let action: () -> Void

    init(title: String, image: String, tint: Color, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.tint = tint
        self.action = action
    }

    var body: some View {
        Button {
            print(title)
            action()
        } label: {
            Image(systemName: image)
            Text(title)
        }
        .buttonStyle(.robotControlBorderedButtonStyle(foreground: tint, border: tint))
    }

}
