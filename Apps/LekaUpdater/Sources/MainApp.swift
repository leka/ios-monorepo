// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import SwiftUI

var globalBleManager = BLEManager.live()

@main
struct LekaUpdaterApp: App {
    @StateObject var coordinator = NavigationCoordinator()
    var firmware = FirmwareManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                ConnectionView()
            }
            .environmentObject(coordinator)
            .environmentObject(firmware)
        }
    }
}
