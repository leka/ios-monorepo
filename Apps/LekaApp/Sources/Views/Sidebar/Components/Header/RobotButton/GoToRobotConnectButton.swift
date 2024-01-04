// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct GoToRobotConnectButton: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

    @StateObject var robotViewModel: ConnectedRobotInformationViewModel = .init()

    var body: some View {
        Button {
            self.navigationVM.showRobotPicker.toggle()
        } label: {
            HStack(spacing: 10) {
                RobotConnectionIndicator()
                self.buttonContent
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(10)
            .frame(height: 100)
        }
        .contentShape(Rectangle())
    }

    // MARK: Private

    @ViewBuilder
    private var buttonContent: some View {
        if self.robotViewModel.isConnected {
            VStack(alignment: .leading, spacing: 4) {
                Text("Connecté à")
                Text(self.robotViewModel.name)
                    .font(self.metrics.reg16)
                self.robotCharginStatusAndBattery
            }
            .font(self.metrics.reg12)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        } else {
            Text("Connectez-vous à votre Leka")
                .font(self.metrics.reg16)
                .multilineTextAlignment(.leading)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
    }

    private var robotCharginStatusAndBattery: some View {
        HStack(spacing: 5) {
            Text(verbatim: "LekaOS v\(self.robotViewModel.osVersion)")
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
                .foregroundColor(.gray)
                .monospacedDigit()
        }
    }
}

#Preview {
    GoToRobotConnectButton()
        .environmentObject(UIMetrics())
        .environmentObject(NavigationViewModel())
}
