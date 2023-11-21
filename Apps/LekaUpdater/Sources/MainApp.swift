// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import SwiftUI

var globalFirmwareManager = FirmwareManager()
var globalBleManager = BLEManager.live()

@main
struct LekaUpdaterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
