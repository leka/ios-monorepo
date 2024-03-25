// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ConnectedRobotView

public struct ConnectedRobotView: View {
    // MARK: Public

    public var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 30) {
                DesignKitAsset.Images.robotFaceSimple.swiftUIImage
                    .background(
                        DesignKitAsset.Colors.lekaGreen.swiftUIColor,
                        in: Circle().inset(by: -20.0)
                    )
                VStack(alignment: .leading, spacing: 5) {
                    Text(self.connectedRobotInformationViewModel.name)
                        .font(.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.primary)
                    Text(l10n.ConnectedRobotView.serialNumberLabel(self.connectedRobotInformationViewModel.serialNumber))
                        .font(.caption)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.secondary)
                    self.robotChargingStatusAndBattery
                }
            }

            Button {
                let animation = Animation.easeOut(duration: 0.5)
                withAnimation(animation) {
                    self.viewModel.disconnectFromRobot()
                }
            } label: {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text(l10n.RobotKit.RobotConnectionView.disconnectButton)
                }
                .frame(minWidth: 200)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(String(l10n.ConnectedRobotView.navigationTitle.characters))
    }

    // MARK: Internal

    @StateObject var connectedRobotInformationViewModel: ConnectedRobotInformationViewModel = .init()
    @StateObject var viewModel: RobotConnectionViewModel

    @Environment(\.dismiss) var dismiss

    // MARK: Private

    private var robotChargingStatusAndBattery: some View {
        HStack(spacing: 5) {
            Text(verbatim: "LekaOS v\(self.connectedRobotInformationViewModel.osVersion)")
                .font(.footnote)
                .foregroundColor(.gray)

            if self.connectedRobotInformationViewModel.isCharging {
                Image(systemName: "bolt.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "bolt.slash.circle")
                    .foregroundColor(.gray.opacity(0.6))
            }

            let battery = BatteryViewModel(level: self.connectedRobotInformationViewModel.battery)

            Image(systemName: battery.name)
                .foregroundColor(battery.color)

            Text(verbatim: "\(battery.level)%")
                .font(.footnote)
                .foregroundColor(.gray)
                .monospacedDigit()
        }
    }
}

// MARK: - l10n.ConnectedRobotView

extension l10n {
    enum ConnectedRobotView {
        static let navigationTitle = LocalizedString(
            "robotkit.connected_robot_view.navigation_title",
            bundle: RobotKitResources.bundle,
            value: "You are connected",
            comment: "The title of the connected robot view"
        )

        static let serialNumberLabel = LocalizedStringInterpolation(
            "robotkit.connected_robot_view.serial_number_label",
            bundle: RobotKitResources.bundle,
            value: "S/N: %1$@",
            comment: "The title of the connected robot view"
        )
    }
}

#Preview {
    let viewModel: RobotConnectionViewModel = .mock()
    return Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                ConnectedRobotView(viewModel: viewModel)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
}