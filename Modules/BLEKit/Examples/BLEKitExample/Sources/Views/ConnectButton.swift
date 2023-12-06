// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import SwiftUI

// MARK: - ConnectButton

struct ConnectButton: View {
    // MARK: Internal

    // MARK: - Environment variables

    @EnvironmentObject var robotListViewModel: RobotListViewModel

    // MARK: - Public views

    var body: some View {
        Button {
            if robotListViewModel.connectedRobotPeripheral == nil, robotListViewModel.selectedRobotDiscovery != nil {
                connectToRobot()
            } else {
                disconnectFromRobot()
            }
        } label: {
            if robotListViewModel.connectedRobotPeripheral == nil {
                disconnectedView
            } else {
                connectedView
            }
        }
        .opacity(
            (robotListViewModel.connectedRobotPeripheral == nil && robotListViewModel.selectedRobotDiscovery == nil)
                ? 0.5 : 1.0
        )
        .disabled(
            robotListViewModel.connectedRobotPeripheral == nil && robotListViewModel.selectedRobotDiscovery == nil)
    }

    // MARK: Private

    // MARK: - Private views

    private var connectedView: some View {
        HStack(spacing: 10) {
            Text("Disconnect")
                .font(.headline)
            Image(systemName: "link.circle")
                .font(.title)
        }
        .foregroundColor(.red)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.red, lineWidth: 2)
        }
    }

    private var disconnectedView: some View {
        HStack(spacing: 10) {
            Text(
                { () -> String in
                    guard let name = robotListViewModel.selectedRobotDiscovery?.name else {
                        return "Select a robot to connect"
                    }
                    return "Connect to \(name)"
                }()
            )
            .monospacedDigit()
            .font(.headline)
            Image(systemName: "link.circle.fill")
                .font(.title)
        }
        .foregroundColor(.white)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(.green)
        .cornerRadius(10)
    }

    private func connectToRobot() {
        robotListViewModel.connectToSelectedPeripheral()
    }

    private func disconnectFromRobot() {
        robotListViewModel.disconnectFromConnectedPeripheral()
    }
}

// MARK: - ConnectButton_Previews

struct ConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectButton()
            .environmentObject(RobotListViewModel.mock())
    }
}
