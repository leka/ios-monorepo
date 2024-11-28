// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI
import Version

// MARK: - ConnectedRobotView

public struct ConnectedRobotView: View {
    // MARK: Lifecycle

    init(robot: Robot) {
        _connectedRobotInformationViewModel = StateObject(
            wrappedValue: .init(robot: robot)
        )
    }

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
                    HStack {
                        self.robotOsVersion
                        self.robotChargingStatusAndBattery
                    }
                    if self.robotNotUpToDate {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(.white, .red)
                            Text(l10n.ConnectedRobotView.robotNotUpToDateAlert)
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            VStack {
                if self.robotNotUpToDate, self.isNotLekaUpdater {
                    Button {
                        let appURL = URL(string: "LekaUpdater://")
                        let appStoreURL = URL(string: "https://apps.apple.com/app/leka-updater/id6446940960")!

                        if let appURL, UIApplication.shared.canOpenURL(appURL) {
                            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        }
                    } label: {
                        Label(
                            String(l10n.ConnectedRobotView.updateButton.characters),
                            systemImage: "arrow.triangle.2.circlepath"
                        )
                        .frame(minWidth: 200)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .padding(.bottom)
                }

                Button {
                    self.presentAlertRenameRobot = true
                } label: {
                    Label(
                        String(l10n.ConnectedRobotView.renameButton.characters),
                        systemImage: "pencil.circle"
                    )
                    .frame(minWidth: 200)
                }
                .buttonStyle(.bordered)

                Button {
                    let animation = Animation.easeOut(duration: 0.5)
                    withAnimation(animation) {
                        BLEManager.shared.disconnect()
                    }
                } label: {
                    Label {
                        Text(l10n.ConnectedRobotView.disconnectButton)
                    } icon: {
                        Image(systemName: "xmark.circle")
                    }
                    .frame(minWidth: 200)
                    .foregroundColor(.red)
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle(String(l10n.ConnectedRobotView.navigationTitle.characters))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .alert(
            String(l10n.ConnectedRobotView.renameAlertTitle.characters),
            isPresented: self.$presentAlertRenameRobot
        ) {
            TextField(
                String(l10n.ConnectedRobotView.renameAlertTextFieldPlaceholder.characters),
                text: self.$newRobotName
            )
            .autocorrectionDisabled()

            Button(
                String(l10n.ConnectedRobotView.renameAlertButtonLabel.characters),
                role: .destructive
            ) {
                Robot.shared.rename(in: self.newRobotName)
                self.dismiss()
            }
            .disabled(self.newRobotName.isEmpty)

            Button(
                String(l10n.ConnectedRobotView.renameAlertCancelButtonLabel.characters),
                role: .cancel
            ) {
                self.newRobotName = ""
            }
        } message: {
            Text(l10n.ConnectedRobotView.renameAlertMessage)
        }
    }

    // MARK: Internal

    @StateObject var connectedRobotInformationViewModel: ConnectedRobotInformationViewModel

    @Environment(\.dismiss) var dismiss

    // MARK: Private

    @StateObject private var styleManager: StyleManager = .shared
    @State private var newRobotName: String = ""
    @State private var presentAlertRenameRobot: Bool = false

    @FocusState private var focusedNameEdition: Bool
    @State private var showNotUpToDateAlert: Bool = false

    // swiftlint:disable:next force_cast
    private let isNotLekaUpdater = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String != "LekaUpdater"

    private var robotNotUpToDate: Bool {
        guard let osVersion = Version(tolerant: self.connectedRobotInformationViewModel.osVersion) else {
            return false
        }
        let versionIsLatest = osVersion >= Robot.kLatestFirmwareVersion
        if versionIsLatest {
            return false
        } else {
            return true
        }
    }

    private var robotOsVersion: some View {
        HStack {
            Text(verbatim: "LekaOS v\(self.connectedRobotInformationViewModel.osVersion)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    private var robotChargingStatusAndBattery: some View {
        HStack(spacing: 5) {
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
            value: "Connected Device",
            comment: "The title of the connected robot view"
        )

        static let serialNumberLabel = LocalizedStringInterpolation(
            "robotkit.connected_robot_view.serial_number_label",
            bundle: RobotKitResources.bundle,
            value: "S/N: %1$@",
            comment: "The title of the connected robot view"
        )

        static let robotNotUpToDateAlert = LocalizedString(
            "robotkit.connected_robot_view.robot_not_up_to_date_alert",
            bundle: RobotKitResources.bundle,
            value: "An update for Leka is available",
            comment: "Update is available alert"
        )

        static let updateButton = LocalizedString(
            "robotkit.robot_connect_view.update_button",
            bundle: RobotKitResources.bundle,
            value: "Update",
            comment: "The title of the update button"
        )

        static let renameButton = LocalizedString(
            "robotkit.connected_robot_view.rename_button",
            bundle: RobotKitResources.bundle,
            value: "Rename",
            comment: "The title of the rename button"
        )

        static let disconnectButton = LocalizedString(
            "robotkit.robot_connect_view.disconnect_button",
            bundle: RobotKitResources.bundle,
            value: "Disconnect",
            comment: "The title of the disconnect button"
        )

        static let renameAlertTitle = LocalizedString(
            "robotkit.connected_robot_view.rename_alert_title",
            bundle: RobotKitResources.bundle,
            value: "Rename Device",
            comment: "The title of the alert when renaming the robot"
        )

        static let renameAlertMessage = LocalizedString(
            "robotkit.connected_robot_view.rename_alert_message",
            bundle: RobotKitResources.bundle,
            value: "Renaming requires a quick device restart to apply changes.",
            comment: "The message of the alert when renaming the robot"
        )

        static let renameAlertTextFieldPlaceholder = LocalizedString(
            "robotkit.connected_robot_view.rename_alert_text_field_placeholder",
            bundle: RobotKitResources.bundle,
            value: "New device name",
            comment: "The placeholder of the text field when renaming the robot"
        )

        static let renameAlertButtonLabel = LocalizedString(
            "robotkit.connected_robot_view.rename_alert_button_label",
            bundle: RobotKitResources.bundle,
            value: "Rename & Restart",
            comment: "The button label of the alert when renaming the robot"
        )

        static let renameAlertCancelButtonLabel = LocalizedString(
            "robotkit.connected_robot_view.rename_alert_cancel_button_label",
            bundle: RobotKitResources.bundle,
            value: "Cancel",
            comment: "The cancel button label of the alert when renaming the robot"
        )
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                ConnectedRobotView(robot: Robot.mock(osVersion: .init(1, 0, 0)))
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
}
