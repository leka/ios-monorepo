// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Copied from RobotKit

import DesignKit
import SwiftUI

struct RobotDiscoveryView: View {

    // MARK: - Private variables

    // TODO (@ladislas): try with simple object, not state, as data comes from above
    @StateObject private var discovery: RobotDiscoveryViewModel
    @State private var rotation: CGFloat = 0.0

    // MARK: - Public functions

    public init(discovery: RobotDiscoveryViewModel) {
        self._discovery = StateObject(wrappedValue: discovery)
    }

    // MARK: - Views

    var body: some View {
        VStack {
            robotFace
            robotName
            robotBatteryAndChargingStatus
            robotOsVersion
        }
        .frame(width: 200, height: 280)
        .animation(.default, value: discovery.status == .connected)
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
            .background(
                DesignKitAsset.Colors.lekaGreen.swiftUIColor,
                in: Circle().inset(by: discovery.status == .connected ? -26 : 2)
            )
            .padding(.bottom, 30)
    }

    private var robotName: some View {
        Text(discovery.name)
            .font(.title3)
    }

    private var robotBatteryAndChargingStatus: some View {
        HStack {
            if discovery.isCharging {
                Image(systemName: "bolt.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "bolt.slash.circle")
                    .foregroundColor(.gray.opacity(0.6))
            }

            HStack(spacing: 5) {
                switch discovery.battery {
                    case 0..<10:
                        Image(systemName: "battery.0")
                            .foregroundColor(.red)
                    case 10..<25:
                        Image(systemName: "battery.25")
                            .foregroundColor(.red)
                    case 25..<45:
                        Image(systemName: "battery.25")
                            .foregroundColor(.orange)
                    case 45..<70:
                        Image(systemName: "battery.50")
                            .foregroundColor(.yellow)
                    case 70..<95:
                        Image(systemName: "battery.75")
                            .foregroundColor(.green)
                    default:
                        Image(systemName: "battery.100")
                            .foregroundColor(.green)
                }

                Text("\(discovery.battery)%")
                    .foregroundColor(.gray)
            }
        }
    }

    private var robotOsVersion: some View {
        Text("LekaOS v\(discovery.osVersion)")
            .font(.caption)
            .foregroundColor(.gray)
    }

}

struct RobotGridCellView_Previews: PreviewProvider {
    struct RobotGridCellViewWithViewModels: View {

        @StateObject var disconnectedViewModel = RobotDiscoveryViewModel(
            name: "Leka .disconnected", battery: Int.random(in: 0...100), isCharging: Bool.random(), osVersion: "1.2.3",
            status: .unselected)

        @StateObject var selectedViewModel = RobotDiscoveryViewModel(
            name: "Leka .selected", battery: Int.random(in: 0...100), isCharging: Bool.random(), osVersion: "1.2.3",
            status: .selected)

        @StateObject var connectedViewModel = RobotDiscoveryViewModel(
            name: "Leka .connected", battery: Int.random(in: 0...100), isCharging: Bool.random(), osVersion: "1.2.3",
            status: .connected)

        var body: some View {
            HStack(spacing: 60) {
                RobotDiscoveryView(discovery: disconnectedViewModel)
                RobotDiscoveryView(discovery: selectedViewModel)
                    .onLongPressGesture {
                        if selectedViewModel.status == .selected {
                            selectedViewModel.status = .connected
                        } else {
                            selectedViewModel.status = .selected
                        }
                    }
                RobotDiscoveryView(discovery: connectedViewModel)
            }
        }
    }

    static var previews: some View {
        RobotGridCellViewWithViewModels()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
