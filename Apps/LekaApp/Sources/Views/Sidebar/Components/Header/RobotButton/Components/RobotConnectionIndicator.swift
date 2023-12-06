// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct RobotConnectionIndicator: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    @StateObject var robotViewModel: ConnectedRobotInformationViewModel = ConnectedRobotInformationViewModel()

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    robotViewModel.isConnected
                        ? DesignKitAsset.Colors.lekaGreen.swiftUIColor : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                )
                .opacity(0.4)

            Image(
                uiImage:
                robotViewModel.isConnected
                    ? DesignKitAsset.Images.robotConnected.image : DesignKitAsset.Images.robotDisconnected.image
            )
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .frame(width: 44, height: 44, alignment: .center)

            Circle()
                .stroke(
                    robotViewModel.isConnected
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
                .frame(width: diameter, height: diameter)
                .opacity(isAnimated ? 0.0 : 0.8)
                .animation(
                    Animation.easeInOut(duration: 1.5).delay(5).repeatForever(autoreverses: false), value: diameter
                )
                .opacity(robotViewModel.isConnected ? 1 : 0.0)
        )
        .overlay(
            alignment: .topTrailing,
            content: {
                badgeView
            }
        )
        .onAppear {
            isAnimated = true
            diameter = isAnimated ? 100 : 0
        }
    }

    // MARK: Private

    @State private var isAnimated: Bool = false
    @State private var diameter: CGFloat = 0

    @ViewBuilder private var badgeView: some View {
        if !robotViewModel.isConnected {
            Image(systemName: "exclamationmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
                .font(metrics.reg19)
                .frame(maxWidth: 22, maxHeight: 22)
        }
    }
}
