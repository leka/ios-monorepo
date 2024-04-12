// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import DesignKit
import GameEngineKit
import LocalizationKit
import RobotKit
import SwiftUI

extension Bundle {
    static var version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    static var buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
}

// MARK: - MainView

struct MainView: View {
    // MARK: Internal

    @ObservedObject var navigation: Navigation = .shared
    @ObservedObject var authManagerViewModel = AuthManagerViewModel.shared
    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        NavigationSplitView {
            List(selection: self.$navigation.selectedCategory) {
                if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                    EditCaregiverLabel()
                } else {
                    NoAccountConnectedLabel()
                }

                Button {
                    self.navigation.sheetContent = .robotConnection
                } label: {
                    RobotConnectionLabel()
                }
                .listRowInsets(EdgeInsets(top: 0, leading: -8, bottom: -8, trailing: -8))

                Section(String(l10n.MainView.Sidebar.sectionInformation.characters)) {
                    CategoryLabel(category: .home)
                }

                Section(String(l10n.MainView.Sidebar.sectionContent.characters)) {
                    CategoryLabel(category: .curriculums)
                    CategoryLabel(category: .activities)
                    CategoryLabel(category: .gamepads)
                }

                if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                    Section(String(l10n.MainView.Sidebar.sectionUsers.characters)) {
                        CategoryLabel(category: .caregivers)
                        CategoryLabel(category: .carereceivers)
                    }
                }

                #if DEVELOPER_MODE
                    Section("Developer Mode") {
                        CategoryLabel(category: .allActivities)
                        CategoryLabel(category: .rasterImageList)
                        CategoryLabel(category: .vectorImageList)
                        CategoryLabel(category: .news)
                        CategoryLabel(category: .resources)
                    }
                #endif

                VStack(alignment: .center, spacing: 20) {
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                        Button {
                            self.navigation.sheetContent = .settings
                        } label: {
                            SettingsLabel()
                        }
                    }

                    Text("My Leka App - Version \(Bundle.version!) (\(Bundle.buildNumber!))")
                        .foregroundColor(.gray)
                        .font(.caption2)

                    LekaLogo(width: 50)
                }
                .frame(maxWidth: .infinity)
            }
            // TODO: (@ladislas) remove if not necessary
            // .disabled(navigation.disableUICompletly)
        } detail: {
            NavigationStack(path: self.$navigation.path) {
                switch self.navigation.selectedCategory {
                    case .home:
                        Text("Home")

                    case .curriculums:
                        CategoryCurriculumsView()

                    case .activities:
                        CategoryActivitiesView()

                    case .gamepads:
                        CategoryGamepadsView()

                    case .caregivers:
                        CaregiverList()

                    case .carereceivers:
                        CarereceiverList()

                    // ? DEVELOPER_MODE
                    case .allActivities:
                        AllActivitiesView()

                    case .rasterImageList:
                        DebugImageListView(images: ContentKit.listRasterImages())
                            .navigationTitle("Raster Image List (.png, .jpg, .jpeg)")

                    case .vectorImageList:
                        DebugImageListView(images: ContentKit.listVectorImages())
                            .navigationTitle("Vector Image List (.svg)")

                    case .news:
                        NewsView()

                    case .resources:
                        ResourcesView()

                    case .none:
                        Text("Select a category")
                            .font(.largeTitle)
                            .bold()
                }
            }
        }
        .id(self.authManagerViewModel.userAction)
        .fullScreenCover(item: self.$navigation.fullScreenCoverContent) {
            self.navigation.fullScreenCoverContent = nil
            self.navigation.currentActivity = nil
        } content: { content in
            NavigationStack {
                switch content {
                    case .welcomeView:
                        WelcomeView()
                    case let .activityView(carereceiver):
                        ActivityView(activity: self.navigation.currentActivity!, reinforcer: carereceiver?.reinforcer ?? .rainbow)
                }
            }
        }
        .sheet(item: self.$navigation.sheetContent) {
            self.navigation.sheetContent = nil
        } content: { content in
            NavigationStack {
                switch content {
                    case .robotConnection:
                        RobotConnectionView(viewModel: RobotConnectionViewModel())
                            .navigationBarTitleDisplayMode(.inline)
                    case .settings:
                        SettingsView()
                            .navigationBarTitleDisplayMode(.inline)
                    case .editCaregiver:
                        EditCaregiverView(caregiver: self.caregiverManagerViewModel.currentCaregiver!)
                            .navigationBarTitleDisplayMode(.inline)
                    case .createCaregiver:
                        CreateCaregiverView()
                            .navigationBarTitleDisplayMode(.inline)
                    case .caregiverPicker:
                        CaregiverPicker()
                            .navigationBarTitleDisplayMode(.inline)
                    case let .carereceiverPicker(activity):
                        CarereceiverPicker(onDismiss: {
                            // nothing to do
                        }, onSelected: { carereceiver in
                            self.carereceiverManager.setCurrentCarereceiver(to: carereceiver)
                            self.navigation.currentActivity = activity
                            self.navigation.fullScreenCoverContent = .activityView(carereceiver: carereceiver)
                        }, onSkip: {
                            self.navigation.currentActivity = activity
                            self.navigation.fullScreenCoverContent = .activityView(carereceiver: nil)
                        })
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .onAppear {
            guard self.authManagerViewModel.userAuthenticationState == .loggedIn else {
                return
            }
            self.persistentDataManager.checkInactivity()
        }
        .onChange(of: self.scenePhase) { newPhase in
            guard self.authManagerViewModel.userAuthenticationState == .loggedIn else {
                return
            }
            switch newPhase {
                case .active:
                    self.persistentDataManager.checkInactivity()
                case .inactive,
                     .background:
                    self.persistentDataManager.updateLastActiveTimestamp()
                    if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                        self.persistentDataManager.lastActiveCaregiverID = currentCaregiverID
                    }
                @unknown default:
                    break
            }
        }
        .onReceive(self.authManagerViewModel.$userAuthenticationState) { state in
            if state == .loggedIn {
                self.persistentDataManager.checkInactivity()
            }
        }
        .onReceive(self.persistentDataManager.inactivityTimeoutPublisher) { isTimedOut in
            if isTimedOut {
                self.caregiverManager.resetCurrentCaregiver()
                guard self.navigation.sheetContent == nil, self.navigation.fullScreenCoverContent == nil else {
                    return
                }
                self.navigation.sheetContent = .caregiverPicker
            } else {
                guard let storedCaregiverID = self.persistentDataManager.lastActiveCaregiverID else {
                    self.navigation.sheetContent = .caregiverPicker
                    return
                }
                self.caregiverManager.setCurrentCaregiver(byID: storedCaregiverID)
            }
        }
        .onChange(of: self.caregiverManagerViewModel.currentCaregiver) { currentCaregiver in
            if currentCaregiver != nil {
                self.styleManager.colorScheme = self.caregiverManagerViewModel.currentCaregiver!.colorScheme
                self.styleManager.accentColor = self.caregiverManagerViewModel.currentCaregiver!.colorTheme.color
            }
        }
    }

    // MARK: Private

    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var persistentDataManager: PersistentDataManager = .shared
    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared
}

#Preview {
    MainView()
        .previewInterfaceOrientation(.landscapeLeft)
}
