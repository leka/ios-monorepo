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
        #if PRODUCTION_BUILD
            // TODO: (@ladislas) Use PROD db when app is stable
            // let googleServiceInfoPlistName = "GoogleServiceInfo+PROD"
            let googleServiceInfoPlistName = "GoogleServiceInfo+TESTFLIGHT"
        #elseif TESTFLIGHT_BUILD
            let googleServiceInfoPlistName = "GoogleServiceInfo+TESTFLIGHT"
        #elseif DEVELOPER_MODE
            let googleServiceInfoPlistName = "GoogleServiceInfo+DEV"
        #else
            let googleServiceInfoPlistName = "GoogleServiceInfo+NOT_FOUND"
        #endif

        guard let googleServiceInfoPlistPath = Bundle.main.path(forResource: googleServiceInfoPlistName, ofType: "plist"),
              let options = FirebaseOptions(contentsOfFile: googleServiceInfoPlistPath)
        else {
            log.critical("\(googleServiceInfoPlistName).plist is missing!")
            fatalError("\(googleServiceInfoPlistName).plist is missing!")
        }

        log.warning("Firebase options: \(options)")
        FirebaseApp.configure(options: options)
    }

    // MARK: Internal

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var styleManager: StyleManager = .shared

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
