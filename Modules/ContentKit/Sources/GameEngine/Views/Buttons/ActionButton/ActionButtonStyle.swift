// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    var progress: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fill(
                        Color.white, strokeBorder: DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                        lineWidth: 4
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0, to: self.progress)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.2), value: self.progress)
                    )
            )
            .contentShape(Circle())
    }
}

#Preview {
    HStack(spacing: 80) {
        Button {
            print("Pressed!")
        } label: {
            Text("Press me")
                .frame(width: 200, height: 200)
        }
        .buttonStyle(ActionButtonStyle(progress: 0.0))

        Button {
            print("Pressed!")
        } label: {
            Text("Press me")
                .frame(width: 200, height: 200)
        }
        .buttonStyle(ActionButtonStyle(progress: 0.5))

        Button {
            print("Pressed!")
        } label: {
            Text("Press me")
                .frame(width: 200, height: 200)
        }
        .buttonStyle(ActionButtonStyle(progress: 1.0))
    }
}
