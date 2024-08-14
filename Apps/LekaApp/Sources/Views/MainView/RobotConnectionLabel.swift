// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - RobotConnectionLabel

struct RobotConnectionLabel: View {
    // MARK: Internal

    var body: some View {
        HStack(spacing: 10) {
            IconIndicator(isConnected: self.robotViewModel.isConnected)
                .onTapGestureIf(self.robotViewModel.isConnected,
                                closure: {
                                    Robot.shared.randomLight()
                                })
                .overlay(alignment: .topTrailing) {
                    if self.robotNotUpToDate {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.white, .red)
                    }
                }
            self.buttonContent
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(self.backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    // MARK: Private

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)

    @StateObject private var robotViewModel: ConnectedRobotInformationViewModel = .init()

    private var robotNotUpToDate: Bool {
        let osVersion = self.robotViewModel.osVersion
        if osVersion == "(n/a)" || osVersion.isEmpty {
            return false
        }
        let versionIsLatest = osVersion == Robot.kLatestFirmwareVersion
        if versionIsLatest {
            return false
        } else {
            return true
        }
    }

    @ViewBuilder
    private var buttonContent: some View {
        if self.robotViewModel.isConnected {
            VStack(alignment: .leading, spacing: 4) {
                Text(l10n.RobotConnectionLabel.textConnectedTo)
                    .font(.caption2)

                Text(self.robotViewModel.name)
                    .font(.subheadline)

                HStack(spacing: 5) {
                    self.robotOsVersion
                    self.robotChargingStatusAndBattery
                }
            }
        } else {
            Text(l10n.RobotConnectionLabel.textNotConnected)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
    }

    private var robotOsVersion: some View {
        Text(verbatim: "LekaOS v\(self.robotViewModel.osVersion)")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var robotChargingStatusAndBattery: some View {
        HStack(spacing: 5) {
            if self.robotViewModel.isCharging {
                Image(systemName: "bolt.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "bolt.slash.circle")
                    .foregroundColor(.gray.opacity(0.6))
            }

            let battery = BatteryViewModel(level: robotViewModel.battery)

            Image(systemName: battery.name)
                .foregroundColor(battery.color)

            Text(verbatim: "\(battery.level)%")
                .font(.footnote)
                .foregroundColor(.gray)
                .monospacedDigit()
        }
    }
}

// MARK: - l10n.RobotConnectionLabel

// swiftlint:disable line_length

extension l10n {
    enum RobotConnectionLabel {
        static let textConnectedTo = LocalizedString("lekaapp.robot_connection_label.text_connected_to", value: "Connected to", comment: "Connected to xxx robot label")

        static let textNotConnected = LocalizedString("lekaapp.robot_connection_label.text_not_connected", value: "Connect to your Leka", comment: "Connect to your Leka label")
    }
}

// swiftlint:enable line_length

#Preview {
    NavigationSplitView(sidebar: {
        List {
            HStack {
                Spacer()
                LekaLogo(width: 80)
                Spacer()
            }
            Button {} label: {
                RobotConnectionLabel()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: -8, bottom: -8, trailing: -8))

            Section("Information") {
                Label("What's new?", systemImage: "lightbulb.max")
                Label("Resources", systemImage: "book.and.wrench")
            }
        }
    }, detail: {
        EmptyView()
    })
}
