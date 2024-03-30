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
                    CategoryLabel(category: .news)
                    CategoryLabel(category: .resources)
                }

                Section(String(l10n.MainView.Sidebar.sectionContent.characters)) {
                    CategoryLabel(category: .curriculums)
                    CategoryLabel(category: .activities)
                    CategoryLabel(category: .remotes)
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
                        CategoryLabel(category: .developerModeImageListPNG)
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

                    case .news:
                        NewsView()

                    case .resources:
                        ResourcesView()

                    case .curriculums:
                        CurriculumsView()

                    case .activities:
                        ActivitiesView()

                    case .remotes:
                        RemotesView()

                    case .caregivers:
                        CaregiverList()

                    case .carereceivers:
                        CarereceiverList()

                    case .allActivities:
                        AllActivitiesView()

                    case .developerModeImageListPNG:
                        DebugImageListView(images: ContentKit.listImagesPNG())
                            .navigationTitle("PNG Image List")

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
                    case .activityView:
                        ActivityView(activity: self.navigation.currentActivity!)
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
                            self.navigation.fullScreenCoverContent = .activityView
                        }, onSkip: {
                            self.navigation.currentActivity = activity
                            self.navigation.fullScreenCoverContent = .activityView
                        })
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    // MARK: Private

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared
}

#Preview {
    MainView()
        .previewInterfaceOrientation(.landscapeLeft)
}
