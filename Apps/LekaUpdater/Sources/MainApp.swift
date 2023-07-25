// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import SwiftUI

var globalBleManager = BLEManager.live()

@main
struct LekaUpdaterApp: App {
    @StateObject var router = ViewRouter()
    var firmware = FirmwareManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch router.currentPage {
                    case .connection:
                        ConnectionView()
                            .environmentObject(router)
                            .environmentObject(firmware)
                    case .information:
                        InformationView()
                            .environmentObject(firmware)
                }
            }
        }
    }
}
