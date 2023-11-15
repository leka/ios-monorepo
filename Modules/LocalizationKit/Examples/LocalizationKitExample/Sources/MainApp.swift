// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

@main
struct LocalizationKitExample: App {

    @Environment(\.openURL) var openURL

    var body: some Scene {
        WindowGroup {
            VStack {
                Button("Open Settings") {
                    openAppSettings()
                }
                MainView()
            }
        }
    }

    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }

}
