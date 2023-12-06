// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

// MARK: - SendDataButton

struct SendDataButton: View {
    // MARK: Internal

    // MARK: - Environment properties

    @EnvironmentObject var robotListViewModel: RobotListViewModel

    // MARK: - Public views

    var body: some View {
        Button {
            sendData()
        } label: {
            labelView
        }
        .opacity((robotListViewModel.connectedRobotPeripheral == nil) ? 0.5 : 1.0)
        .disabled(robotListViewModel.connectedRobotPeripheral == nil)
    }

    // MARK: Private

    // MARK: - Private views

    private var labelView: some View {
        HStack {
            Text(
                (robotListViewModel.connectedRobotPeripheral == nil)
                    ? "Select a robot"
                    : "Send data to \(robotListViewModel.connectedRobotPeripheral?.peripheral.name ?? "nil")")
            Image(systemName: "paperplane.circle.fill")
                .font(.title)
                .foregroundColor(.teal)
        }
        .font(.headline)
        .monospacedDigit()
        .foregroundColor(.teal)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.teal, lineWidth: 2)
        )
    }

    // MARK: - Private functions

    private func sendData() {
        print("Send data")
        robotListViewModel.connectedRobotPeripheral?
            .sendCommand(Data([0x2A, 0x2A, 0x2A, 0x2A, 0x01, 0x50, 0x51, 0x51]))
    }
}

// MARK: - SendDataButton_Previews

struct SendDataButton_Previews: PreviewProvider {
    static var previews: some View {
        SendDataButton()
            .environmentObject(RobotListViewModel.mock())
    }
}
