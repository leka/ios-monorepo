// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct ContentView: View {

    // MARK: - Environment variables

    @StateObject private var robotListViewModel: RobotListViewModel

    // MARK: - Public functions

    init(bleManager: BLEManager) {
        // ? StateObject dependency injection pattern as described here:
        // https://developer.apple.com/documentation/swiftui/stateobject#Initialize-state-objects-using-external-data
        self._robotListViewModel = StateObject(wrappedValue: RobotListViewModel(bleManager: bleManager))
    }

    // MARK: - Views

    var body: some View {
        VStack {
            List(robotListViewModel.availableRobots) { robotDiscovery in
                RobotDiscoveryView(discovery: robotDiscovery)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if robotDiscovery == self.robotListViewModel.selectedRobotDiscovery {
                            print("Unselect \(robotDiscovery)")
                            self.robotListViewModel.selectedRobotDiscovery = nil

                        } else {
                            print("Select \(robotDiscovery.advertisingData.name)")
                            self.robotListViewModel.selectedRobotDiscovery = robotDiscovery
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
        .environmentObject(robotListViewModel)
    }

}

struct ContentView_Previews: PreviewProvider {
    static let bleManager = BLEManager.live()
    static var previews: some View {
        ContentView(bleManager: bleManager)
    }
}
