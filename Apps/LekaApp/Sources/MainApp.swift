// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import Combine
import ContentKit
import DesignKit
import FirebaseKit
import LocalizationKit
import LogKit
import SwiftUI
import UtilsKit

let log = LogKit.createLoggerFor(app: "LekaApp")

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        // ? Enable Firebase Analytics DebugView for TestFlight/Developer mode
        #if TESTFLIGHT_BUILD || DEVELOPER_MODE
            UserDefaults.standard.set(true, forKey: "/google/firebase/debug_mode")
            UserDefaults.standard.set(true, forKey: "/google/measurement/debug_mode")
        #endif

        FirebaseKit.shared.configure()

        return true
    }
}

// MARK: - LekaApp

@main
struct LekaApp: App {
    // MARK: Lifecycle

    init() {
        AnalyticsManager.clearDefaultEventParameters()
    }

    // MARK: Internal

    class UpdateStatus: ObservableObject {
        static let shared = UpdateStatus()

        @Published var status: UpdateStatusFetcher.Status = .upToDate
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @Environment(\.colorScheme) var colorScheme
    @StateObject var appUpdateStatus: UpdateStatus = .shared
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
            .onAppear {
                var cancellable: AnyCancellable?
                cancellable = UpdateStatusFetcher().fetch { result in
                    defer { cancellable?.cancel() }
                    guard let status = try? result.get() else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.showMainView = true
                            self.appUpdateStatus.status = .upToDate
                        }
                        return
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.showMainView = true
                        self.appUpdateStatus.status = status
                    }
                }
            }
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

#Preview {
    LoadingView()
}
