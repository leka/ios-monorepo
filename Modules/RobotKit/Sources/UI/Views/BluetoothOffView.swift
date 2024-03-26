// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - BluetoothOffView

public struct BluetoothOffView: View {
    // MARK: Public

    public var body: some View {
        VStack(spacing: 20) {
            Text(l10n.BluetoothOffView.message)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(l10n.BluetoothOffView.instruction)
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .navigationTitle(String(l10n.BluetoothOffView.title.characters))
    }

    // MARK: Private

    @Environment(\.openURL) private var openURL
}

// MARK: - l10n.BluetoothOffView

extension l10n {
    enum BluetoothOffView {
        static let title = LocalizedString(
            "robotkit.robot_connection_view.bluetooth_off_view.title",
            bundle: RobotKitResources.bundle,
            value: "Bluetooth off",
            comment: "The title of the bluetooth off of RobotConnectionErrorsView"
        )

        static let message = LocalizedString(
            "robotkit.robot_connection_view.bluetooth_off_view.message",
            bundle: RobotKitResources.bundle,
            value: "You need Bluetooth to connect to a robot.",
            comment: "The message of the bluetooth off of RobotConnectionErrorsView"
        )

        static let instruction = LocalizedString(
            "robotkit.robot_connection_view.bluetooth_off_view.instruction",
            bundle: RobotKitResources.bundle,
            value: "Go to Settings -> Select Bluetooth in sidebar -> Turn Bluetooth on.",
            comment: "The instruction of the bluetooth off of RobotConnectionErrorsView"
        )
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                BluetoothOffView()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
}
