// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "AccountKitExample")

@main
struct AccountKitExample: App {

    @StateObject var authenticationState = OrganisationAuthState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authenticationState)
        }
    }

}
