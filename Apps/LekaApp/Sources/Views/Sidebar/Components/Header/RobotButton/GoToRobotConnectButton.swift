// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct GoToRobotConnectButton: View {

    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

    @StateObject var robotViewModel: ConnectedRobotInformationViewModel = ConnectedRobotInformationViewModel()

    var body: some View {
        Button {
            navigationVM.showRobotPicker.toggle()
        } label: {
            HStack(spacing: 10) {
                RobotConnectionIndicator()
                buttonContent
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

    @ViewBuilder
    private var buttonContent: some View {
        if robotViewModel.isConnected {
            VStack(alignment: .leading, spacing: 4) {
                Text("Connecté à")
                Text(robotViewModel.name)
                    .font(metrics.reg16)
                robotCharginStatusAndBattery
            }
            .font(metrics.reg12)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        } else {
            Text("Connectez-vous à votre Leka")
                .font(metrics.reg16)
                .multilineTextAlignment(.leading)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
    }

    private var robotCharginStatusAndBattery: some View {
        HStack(spacing: 5) {
            Text(verbatim: "LekaOS v\(robotViewModel.osVersion)")
                .foregroundColor(.gray)

            if robotViewModel.isCharging {
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
