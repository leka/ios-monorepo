// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

extension RobotConnectionLabel {
    struct IconIndicator: View {
        // MARK: Internal

        var isConnected: Bool

        var body: some View {
            ZStack {
                Circle()
                    .fill(
                        self.isConnected
                            ? DesignKitAsset.Colors.lekaGreen.swiftUIColor : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                    )
                    .opacity(0.4)

                Image(
                    uiImage:
                    self.isConnected
                        ? DesignKitAsset.Images.robotConnected.image : DesignKitAsset.Images.robotDisconnected.image
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44, alignment: .center)

                Circle()
                    .stroke(
                        self.isConnected
                            ? DesignKitAsset.Colors.lekaGreen.swiftUIColor
                            : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor,
                        lineWidth: 4
                    )
                    .frame(width: 44, height: 44)
            }
            .frame(width: 67, height: 67, alignment: .center)
            .background(
                Circle()
                    .fill(DesignKitAsset.Colors.lekaGreen.swiftUIColor)
                    .frame(width: self.diameter, height: self.diameter)
                    .opacity(self.isAnimated ? 0.0 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 1.5).delay(5).repeatForever(autoreverses: false), value: self.diameter
                    )
                    .opacity(self.isConnected ? 1 : 0.0)
            )
            .overlay(
                alignment: .topTrailing,
                content: {
                    if !self.isConnected {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.white, .red)
                    }
                }
            )
            .onAppear {
                self.isAnimated = true
                self.diameter = self.isAnimated ? 100 : 0
            }
        }

        // MARK: Private

        @State private var isAnimated: Bool = false
        @State private var diameter: CGFloat = 0
    }
}

#Preview {
    HStack {
        RobotConnectionLabel.IconIndicator(isConnected: true)
        RobotConnectionLabel.IconIndicator(isConnected: false)
    }
}
