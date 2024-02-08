// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import FirebaseCore
import SwiftUI

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

// MARK: - LekaApp

@main
struct LekaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var styleManager: StyleManager = .shared
    @ObservedObject var rootOwnerViewModel = RootOwnerViewModel.shared
    @StateObject var authManagerViewModel = AuthManagerViewModel.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                    self.rootOwnerViewModel.isWelcomeViewPresented = self.authManagerViewModel.userAuthenticationState != .loggedIn
                }
                .fullScreenCover(isPresented: self.$rootOwnerViewModel.isWelcomeViewPresented) {
                    WelcomeView()
                }
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
                .environmentObject(self.authManagerViewModel)
        }
    }
}
