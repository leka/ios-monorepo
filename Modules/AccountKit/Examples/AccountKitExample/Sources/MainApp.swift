// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import FirebaseCore
import LogKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

let log = LogKit.createLoggerFor(app: "AccountKitExample")

// MARK: - AccountKitExample

@main
struct AccountKitExample: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authManager)
        }
    }
}
