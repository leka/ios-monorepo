// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import SwiftUI

var globalBleManager = BLEManager.live()

@main
struct LekaUpdaterApp: App {
    var firmware = FirmwareManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firmware)
        }
    }
}
