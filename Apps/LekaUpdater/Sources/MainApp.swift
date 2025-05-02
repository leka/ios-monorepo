// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "LekaUpdater")
var globalFirmwareManager = FirmwareManager()

// MARK: - LekaUpdaterApp

@main
struct LekaUpdaterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
