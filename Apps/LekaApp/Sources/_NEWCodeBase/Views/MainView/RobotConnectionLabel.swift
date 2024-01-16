// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct RobotConnectionLabel: View {
    // MARK: Internal

    var body: some View {
        HStack(spacing: 10) {
            IconIndicator(isConnected: self.robotViewModel.isConnected)
            self.buttonContent
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(self.backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    // MARK: Private

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)

    @StateObject private var robotViewModel: ConnectedRobotInformationViewModel = .init()

    @ViewBuilder
    private var buttonContent: some View {
        if self.robotViewModel.isConnected {
            VStack(alignment: .leading, spacing: 4) {
                Text("Connecté à")
                    .font(.caption2)

                Text(self.robotViewModel.name)
                    .font(.subheadline)

                self.robotChargingStatusAndBattery
            }
        } else {
            Text("Connectez-vous à votre Leka")

                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
    }

    private var robotChargingStatusAndBattery: some View {
        HStack(spacing: 5) {
            Text(verbatim: "LekaOS v\(self.robotViewModel.osVersion)")
                .font(.footnote)
                .foregroundColor(.gray)

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
