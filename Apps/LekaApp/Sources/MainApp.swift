// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import FirebaseCore
import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "LekaApp")

// MARK: - LekaApp

@main
struct LekaApp: App {
    // MARK: Lifecycle

    init() {
        FirebaseApp.configure()
    }

    // MARK: Internal

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var styleManager: StyleManager = .shared
    @ObservedObject var rootOwnerViewModel = RootOwnerViewModel.shared
    @StateObject var authManagerViewModel = AuthManagerViewModel.shared
    @StateObject var caregiverManagerViewModel = CaregiverManagerViewModel.shared
    @StateObject var carereceiverManagerViewModel = CarereceiverManagerViewModel.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                }
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
        }
    }
}
