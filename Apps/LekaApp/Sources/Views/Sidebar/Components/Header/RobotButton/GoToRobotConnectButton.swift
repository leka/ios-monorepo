// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct GoToRobotConnectButton: View {

    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

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
        if robotVM.robotIsConnected {
            VStack(alignment: .leading, spacing: 4) {
                Text("Connecté à")
                Text(robotVM.currentlyConnectedRobotName)
                    .font(metrics.reg16)
                HStack(spacing: 4) {
                    RobotBatteryIndicator(
                        level: $robotVM.robotChargeLevel,
                        charging: $robotVM.robotIsCharging)
                    Text(robotVM.robotOSVersion)
                        .foregroundColor(Color("darkGray"))
                }
            }
            .font(metrics.reg12)
            .foregroundColor(.accentColor)
        } else {
            Text("Connectez vous à votre LEKA.")
                .font(metrics.reg16)
                .foregroundColor(.accentColor)
        }
    }
}
