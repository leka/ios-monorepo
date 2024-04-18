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
    @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared
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
                    self.viewModel.isRobotConnectionPresented = true
                } label: {
                    RobotConnectionLabel()
                }
                .listRowInsets(EdgeInsets(top: 0, leading: -8, bottom: -8, trailing: -8))

                Section(String(l10n.MainView.Sidebar.sectionInformation.characters)) {
                    CategoryLabel(category: .news)
                    CategoryLabel(category: .resources)
                }

                Section(String(l10n.MainView.Sidebar.sectionContent.characters)) {
                    CategoryLabel(category: .curriculums)
                    CategoryLabel(category: .activities)
                    CategoryLabel(category: .remotes)
                    CategoryLabel(category: .sampleActivities)
                }

                Section(String(l10n.MainView.Sidebar.sectionUsers.characters)) {
                    CategoryLabel(category: .carereceivers)
                }

                VStack(alignment: .center, spacing: 20) {
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                        Button {
                            self.rootOwnerViewModel.isSettingsViewPresented = true
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

                    case .sampleActivities:
                        SampleActivityListView()

                    case .carereceivers:
                        CarereceiverList()

                    case .none:
                        Text("Select a category")
                            .font(.largeTitle)
                            .bold()
                }
            }
        }
        .fullScreenCover(isPresented: self.$viewModel.isRobotConnectionPresented) {
            RobotConnectionView(viewModel: RobotConnectionViewModel())
        }
        .fullScreenCover(isPresented: self.$rootOwnerViewModel.isWelcomeViewPresented) {
            WelcomeView()
        }
        .fullScreenCover(isPresented: self.$rootOwnerViewModel.isCaregiverPickerPresented) {
            CaregiverPicker()
        }
        .fullScreenCover(item: self.$navigation.currentActivity) {
            self.navigation.currentActivity = nil
        } content: { activity in
            ActivityView(activity: activity)
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isSettingsViewPresented) {
            SettingsView(isCaregiverPickerPresented: self.$rootOwnerViewModel.isCaregiverPickerPresented)
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isEditCaregiverViewPresented) {
            EditCaregiverView(modifiedCaregiver: self.caregiverManagerViewModel.currentCaregiver!)
        }
        .onReceive(self.authManagerViewModel.$userAuthenticationState) { authState in
            if case authState = .loggedOut {
                if !self.rootOwnerViewModel.isSettingsViewPresented {
                    self.rootOwnerViewModel.isWelcomeViewPresented = true
                }
            }
            if case authState = .loggedIn {
                self.caregiverManager.fetchAllCaregivers()
                self.carereceiverManager.fetchAllCarereceivers()
                if !self.rootOwnerViewModel.isWelcomeViewPresented {
                    self.rootOwnerViewModel.isCaregiverPickerPresented = (self.caregiverManagerViewModel.currentCaregiver == nil)
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
