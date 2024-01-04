// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "AccountKitExample")

// MARK: - AccountKitExample

@main
struct AccountKitExample: App {
    @StateObject var authenticationState = OrganisationAuthState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(self.authenticationState)
        }
    }
}
