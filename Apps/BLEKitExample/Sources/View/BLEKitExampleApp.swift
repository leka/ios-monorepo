// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

// MARK: - BLEKitExampleApp

@main
struct BLEKitExampleApp: App {
    @StateObject var bleManager: BLEManager = .live()
    @StateObject var robot: Robot = .init()
    @StateObject var botVM: BotViewModel = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.bleManager)
                .environmentObject(self.robot)
                .environmentObject(self.botVM)
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot

    var body: some View {
        NavigationView {
            if self.bleManager.connectedPeripheral != nil {
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
