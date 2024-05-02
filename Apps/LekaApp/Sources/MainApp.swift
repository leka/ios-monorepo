// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
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

        guard let googleServiceInfoPlistPath = Bundle.main.path(forResource: googleServiceInfoPlistName, ofType: "plist"),
              let options = FirebaseOptions(contentsOfFile: googleServiceInfoPlistPath)
        else {
            log.critical("\(googleServiceInfoPlistName).plist is missing!")
            fatalError("\(googleServiceInfoPlistName).plist is missing!")
        }

        log.warning("Firebase: \(googleServiceInfoPlistName)")
        log.warning("Firebase options: \(options)")
        FirebaseApp.configure(options: options)
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
                            }
                        }
                }
            }
            .animation(.default, value: self.showMainView)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showMainView = true
                }
            }
        }
    }

    // MARK: Private

    @State private var loaderOpacity: Double = 1.0
    @State private var showMainView: Bool = false
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

#Preview {
    LoadingView()
}
