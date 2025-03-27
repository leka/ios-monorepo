// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "GameEngineKitExample")

// MARK: - GameEngineKitExample

@main
struct GameEngineKitExample: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
