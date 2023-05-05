// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

@main
struct LekaUpdaterApp: App {

    @StateObject var viewRouter = ViewRouter()
    @StateObject var metrics = UIMetrics()
    @StateObject var settings = SettingsViewModel()
    @StateObject var botVM = BotViewModel()

    var body: some Scene {
        WindowGroup {
            //            ContentView()
            BotPicker()
                .environmentObject(viewRouter)
                .environmentObject(metrics)
                .environmentObject(settings)
                .environmentObject(botVM)
        }
    }
}
