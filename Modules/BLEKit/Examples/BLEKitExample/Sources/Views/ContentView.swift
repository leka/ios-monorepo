// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import CombineCoreBluetooth
import SwiftUI

struct ContentView: View {

    // MARK: - Environment variables

    @EnvironmentObject private var robotListViewModel: RobotListViewModel

    // MARK: - Views

    var body: some View {
        VStack {
            List(robotListViewModel.availableRobots) { robot in
                RobotDiscoveryView(discovery: robot)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if robot == self.robotListViewModel.selectedRobotDiscovery {
                            print("Unselect \(robot)")
                            self.robotListViewModel.selectedRobotDiscovery = nil

                        } else {
                            print("Select \(robot.name)")
                            self.robotListViewModel.selectedRobotDiscovery = robot
                        }
                    }
            }
            .disabled(robotListViewModel.connectedRobotPeripheral != nil)
            .listStyle(.plain)
            .padding()

            Divider()
                .padding([.leading, .trailing], 30)

            VStack(spacing: 10) {
                ScanButton()
                ConnectButton()
                SendDataButton()
            }
            .padding(30)

        }
        .navigationTitle("BLEKit Example App")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RobotListViewModel.mock())
    }
}
