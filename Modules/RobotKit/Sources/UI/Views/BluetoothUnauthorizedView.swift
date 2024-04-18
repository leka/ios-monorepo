// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - BluetoothUnauthorizedView

public struct BluetoothUnauthorizedView: View {
    // MARK: Public

    public var body: some View {
        VStack(spacing: 100) {
            Text(l10n.BluetoothUnauthorizedView.message)
                .font(.title2)
                .multilineTextAlignment(.center)

            Button {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                self.openURL(settingsURL)
            } label: {
                HStack {
                    Image(systemName: "gearshape.fill")
                    Text(l10n.BluetoothUnauthorizedView.buttonLabel)
                }
                .frame(minWidth: 200)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(String(l10n.BluetoothUnauthorizedView.title.characters))
    }

    // MARK: Private

    @Environment(\.openURL) private var openURL
}

// MARK: - l10n.BluetoothUnauthorizedView

extension l10n {
    enum BluetoothUnauthorizedView {
        static let title = LocalizedString(
            "robotkit.robot_connection_view.bluetooth_unauthorized_view.title",
            bundle: RobotKitResources.bundle,
            value: "Bluetooth unauthorized",
            comment: "The title of the bluetooth unauthorized of RobotConnectionErrorsView"
        )

        static let message = LocalizedString(
            "robotkit.robot_connection_view.bluetooth_unauthorized_view.message",
            bundle: RobotKitResources.bundle,
            value: """
                You need Bluetooth to connect to a robot.
                Please allow Leka App to use Bluetooth in your device settings
                """,
            comment: "The message of the bluetooth unauthorized of RobotConnectionErrorsView"
        )

        static let buttonLabel = LocalizedString(
            "robotkit.bluetooth_unauthorized_view.button",
            bundle: RobotKitResources.bundle,
            value: "Go to Settings",
            comment: "Label of the button directing to Bluetooth settings of the bluetooth unauthorized of BluetoothUnauthorizedView"
        )
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                BluetoothUnauthorizedView()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
}
