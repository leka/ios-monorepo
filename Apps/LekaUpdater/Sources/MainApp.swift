// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import SwiftUI

var globalBleManager = BLEManager.live()
var globalRobotManager = RobotManager()

@main
struct LekaUpdaterApp: App {
    var firmware = FirmwareManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ConnectionView()
                    .environmentObject(firmware)
            }
        }
    }
}
