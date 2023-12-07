// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

@main
struct BLEKitExample: App {
    var bleManager: BLEManager = .live()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(bleManager: self.bleManager)
            }
        }
    }
}
