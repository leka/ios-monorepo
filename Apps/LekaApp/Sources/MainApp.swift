// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import AppUpdately
import Combine
import ContentKit
import DesignKit
import FirebaseKit
import LocalizationKit
import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "LekaApp")

// MARK: - LekaApp

@main
struct LekaApp: App {
    // MARK: Lifecycle

    init() {
        // ? Set GoogleService-Info.plist based on the build configuration
        #if PRODUCTION_BUILD
            log.warning("PRODUCTION_BUILD")
            let googleServiceInfoPlistName = "GoogleServiceInfo+PROD"
        #elseif TESTFLIGHT_BUILD
            log.warning("TESTFLIGHT_BUILD")
            let googleServiceInfoPlistName = "GoogleServiceInfo+TESTFLIGHT"
        #elseif DEVELOPER_MODE
            log.warning("DEVELOPER_MODE")
            let googleServiceInfoPlistName = "GoogleServiceInfo+DEV"
        #else
            log.warning("NO BUILD CONFIGURATION")
            let googleServiceInfoPlistName = "GoogleServiceInfo+NOT_FOUND"
        #endif

        // ? Enable Firebase Analytics DebugView for TestFlight/Developer mode
        #if TESTFLIGHT_BUILD || DEVELOPER_MODE
            UserDefaults.standard.set(true, forKey: "/google/firebase/debug_mode")
            UserDefaults.standard.set(true, forKey: "/google/measurement/debug_mode")
        #endif

        FirebaseKit.shared.configure(with: googleServiceInfoPlistName)
    }

    // MARK: Internal

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var styleManager: StyleManager = .shared

    var body: some Scene {
        WindowGroup {
            Group {
                if self.showMainView {
                    MainView()
                        .onAppear {
                            self.styleManager.setDefaultColorScheme(self.colorScheme)
                        }
                        .tint(self.styleManager.accentColor)
                        .preferredColorScheme(self.styleManager.colorScheme)
                        .transition(.opacity)
                } else {
                    LoadingView()
                        .onAppear {
                            DispatchQueue.global().async {
                                _ = ContentKit.allActivities
                                _ = ContentKit.allCurriculums
                                _ = ContentKit.allStories
                            }
                        }
                }
            }
            .animation(.default, value: self.showMainView)
            #if PRODUCTION_BUILD
                .onAppear {
                    var cancellable: AnyCancellable?
                    cancellable = UpdateStatusFetcher().fetch { result in
                        defer { cancellable?.cancel() }
                        guard let status = try? result.get() else { return }

                        switch status {
                            case .upToDate,
                                 .newerVersion:
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self.showMainView = true
                                }
                            case .updateAvailable:
                                self.showingUpdateAlert = true
                        }
                    }
                }
                .alert(isPresented: self.$showingUpdateAlert) {
                    Alert(
                        title: Text(l10n.MainApp.UpdateAlert.title),
                        message: Text(l10n.MainApp.UpdateAlert.message),
                        primaryButton: .default(Text(l10n.MainApp.UpdateAlert.action), action: {
                            if let url = URL(string: "https://apps.apple.com/app/leka/id6446940339") {
                                UIApplication.shared.open(url)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.showMainView = true
                            }
                        }),
                        secondaryButton: .cancel {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.showMainView = true
                            }
                        }
                    )
                }
            #else
                .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.showMainView = true
                        }
                    }
            #endif
        }
    }

    // MARK: Private

    @State private var loaderOpacity: Double = 1.0
    @State private var showMainView: Bool = false
    @State private var showingUpdateAlert: Bool = false
}

// MARK: - LoadingView

struct LoadingView: View {
    var body: some View {
        Color.white
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack {
                    Image("LekaLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.black)
                        .padding(.top, 200)
                }
            )
    }
}

// MARK: - l10n.MainApp

// swiftlint:disable nesting

extension l10n {
    enum MainApp {
        enum UpdateAlert {
            static let title = LocalizedString("lekaapp.main_app.update_alert.title", value: "New update available", comment: "The title of the alert to inform the user that an update is available")
            static let message = LocalizedString("lekaapp.main_app.update_alert.message", value: "Enjoy new features by updating to the latest version of Leka!", comment: "The message of the alert to inform the user that an update is available")
            static let action = LocalizedString("lekaapp.main_app.update_alert.action", value: "Update now", comment: "The action button of the alert to inform the user that an update is available")
        }
    }
}

// swiftlint:enable nesting

#Preview {
    LoadingView()
}
