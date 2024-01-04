// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import SwiftUI

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
