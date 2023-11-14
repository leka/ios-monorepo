// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotDiscoveryView: View {

    // MARK: - Private variables

    @State private var rotation: CGFloat = 0.0
    @State private var inset: CGFloat = 0.0

    private var discovery: RobotDiscoveryViewModel

    // MARK: - Public functions

    public init(discovery: RobotDiscoveryViewModel) {
        self.discovery = discovery
    }

    // MARK: - Views

    var body: some View {
        VStack {
            VStack(spacing: 30) {
                robotFace
                robotName
            }
            robotCharginStatusAndBattery
            robotOsVersion
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
    }

    // MARK: - Private views

    private var robotFace: some View {
        DesignKitAsset.Images.robotFaceSimple.swiftUIImage
            .overlay(content: {
                Circle()
                    .inset(by: -10)
                    .stroke(
                        DesignKitAsset.Colors.lekaGreen.swiftUIColor,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .butt,
                            lineJoin: .round,
                            dash: [12, 3])
                    )
                    .opacity(discovery.status == .selected ? 1 : 0)
                    .rotationEffect(.degrees(rotation), anchor: .center)
                    .animation(
                        Animation
                            .linear(duration: 15)
                            .repeatForever(autoreverses: false),
                        value: rotation
                    )
                    .onAppear {
                        rotation = 360
                    }
            })
            .onAppear {
                guard discovery.status == .connected else { return }
                let baseAnimation = Animation.bouncy(duration: 0.5)
                withAnimation(baseAnimation) {
                    inset = -26.0
                }
            }
            .background(
                DesignKitAsset.Colors.lekaGreen.swiftUIColor.opacity(discovery.status == .connected ? 1.0 : 0.0),
                in: Circle().inset(by: inset)
            )
    }

    private var robotName: some View {
        Text(discovery.name)
            .font(.title3)
            .multilineTextAlignment(.center)
            .lineLimit(1)
    }

    private var robotCharginStatusAndBattery: some View {
        HStack {
            if discovery.isCharging {
                Image(systemName: "bolt.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "bolt.slash.circle")
                    .foregroundColor(.gray.opacity(0.6))
            }

            HStack(spacing: 5) {
                Image(systemName: discovery.battery.name)
                    .foregroundColor(discovery.battery.color)
                Text("\(discovery.battery.level)%")
                    .foregroundColor(.gray)
            }
        }
    }

    private var robotOsVersion: some View {
        Text(discovery.osVersion)
            .font(.caption)
            .foregroundColor(.gray)
    }
}

#Preview {

    HStack(spacing: 100) {

        RobotDiscoveryView(discovery: .mock(name: "Leka unselected", status: .unselected))

        RobotDiscoveryView(discovery: .mock(name: "Leka selected", status: .selected))

        RobotDiscoveryView(discovery: .mock(name: "Leka connected", status: .connected))

    }

}
