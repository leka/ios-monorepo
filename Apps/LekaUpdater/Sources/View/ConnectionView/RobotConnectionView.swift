// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Copied from RobotKit

import DesignKit
import SwiftUI

struct RobotConnectionView: View {

    // TODO(@ladislas): review DI - BLEManager, etc.
    @StateObject var robotConnectionViewModel: RobotConnectionViewModel = RobotConnectionViewModel()

    var body: some View {
        VStack(spacing: 60) {
            Spacer()

            RobotGridView()
                .environmentObject(robotConnectionViewModel)

            HStack(spacing: 40) {
                Spacer()
                scanButton
                connectDisconnectButton
                Spacer()
            }
            .padding(.vertical, 20)

            Spacer()
        }
    }

    private var scanButton: some View {
        Button(
            action: {
                robotConnectionViewModel.scanForRobots()
            },
            label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search for robots")
                }

            }
        )
        .buttonStyle(.borderedProminent)
        .tint(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
    }

    private var connectDisconnectButton: some View {
        Button(
            action: {
                if robotConnectionViewModel.disconnected {
                    robotConnectionViewModel.connectToSelectedRobot()
                } else {
                    robotConnectionViewModel.disconnectFromRobot()
                }
            },
            label: {
                HStack {
                    Image(systemName: "checkmark.circle")
                    if robotConnectionViewModel.disconnected {
                        Text("Connect to robot")

                    } else {
                        Text("Disconnect from robot")
                    }
                }
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(robotConnectionViewModel.connected ? DesignKitAsset.Colors.lekaOrange.swiftUIColor : .accentColor)
        .disabled(robotConnectionViewModel.connectionButtonDisabled)
    }
}

struct RobotListView_Previews: PreviewProvider {
    static var previews: some View {
        RobotConnectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
