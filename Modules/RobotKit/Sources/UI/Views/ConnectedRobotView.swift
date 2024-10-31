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
                    VStack {
                        if self.isEditingName {
                            TextField("Enter new name", text: self.$currentRobotName, onCommit: {
                                self.triggerRebootAlertPresented = true
                                self.focusedNameEdition = false
                                self.isEditingName = false
                            })
                            .font(.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.primary)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .focused(self.$focusedNameEdition)
                            .frame(maxWidth: 300)
                        } else {
                            HStack {
                                Text(self.connectedRobotInformationViewModel.name)
                                    .font(.title)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .foregroundColor(.primary)
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title)
                            }
                            .onTapGesture {
                                self.isEditingName = true
                                self.currentRobotName = self.connectedRobotInformationViewModel.name
                                self.focusedNameEdition = true
                            }
                        }
                    }

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
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text(l10n.RobotKit.RobotConnectionView.updateButton)
                        }
                        .frame(minWidth: 200)
                    }
                    .buttonStyle(.borderedProminent)
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
        }
        .navigationTitle(String(l10n.ConnectedRobotView.navigationTitle.characters))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .simultaneousGesture(TapGesture().onEnded {
            self.focusedNameEdition = false
            self.isEditingName = false
        })
        .alert(isPresented: self.$triggerRebootAlertPresented) {
            Alert(
                title: Text(self.waitingForRebootAlertPresented ? "Wait for reboot" : "Warning"),
                message: Text("Your robot will reboot to set the new name"),
                primaryButton: .default(Text("Reboot"), action: {
                    self.isEditingName = false
                    self.rename(in: self.currentRobotName)
                }),
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: Internal

    @StateObject var connectedRobotInformationViewModel: ConnectedRobotInformationViewModel = .init()
    @StateObject var viewModel: RobotConnectionViewModel
    @State private var currentRobotName: String = ""
    @State private var isEditingName: Bool = false
    @State private var triggerRebootAlertPresented: Bool = false

    // swiftlint:disable:next force_cast
    private let isNotLekaUpdater = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String != "LekaUpdater"

    @FocusState private var focusedNameEdition: Bool
    @State private var showNotUpToDateAlert: Bool = false

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

    @Environment(\.dismiss) var dismiss

    // MARK: Private

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

    private func rename(in name: String) {
        let dataName = name.data(using: .utf8)!
        let robotNameCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.Config.Characteristics.robotName,
            serviceUUID: BLESpecs.Config.service,
            onWrite: {
                self.connectedRobotInformationViewModel.robot.reboot()
                self.viewModel.connectedDiscovery = nil
                self.viewModel.selectedDiscovery = nil
                self.dismiss()
            }
        )

        self.connectedRobotInformationViewModel.robot.connectedPeripheral?.send(dataName, forCharacteristic: robotNameCharacteristic)
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

        static let robotNotUpToDateAlert = LocalizedString(
            "robotkit.connected_robot_view.robot_not_up_to_date_alert",
            bundle: RobotKitResources.bundle,
            value: "An update for Leka is available",
            comment: "Update is available alert"
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
