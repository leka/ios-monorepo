// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

@main
struct BLEKitExampleApp: App {
    @StateObject var bleManager: BLEManager = BLEManager.live()
    @StateObject var robot: Robot = Robot()
    @StateObject var botVM: BotViewModel = BotViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bleManager)
                .environmentObject(robot)
                .environmentObject(botVM)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot

    var body: some View {
        NavigationView {
            if bleManager.connectedPeripheral != nil {
                RobotView()
                    .navigationTitle("BLEKitExampleApp")
            } else {
                RobotListView()
                    .navigationTitle("BLEKitExampleApp")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
