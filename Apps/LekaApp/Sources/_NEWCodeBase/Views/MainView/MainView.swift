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
                    EditCaregiverLabel(isCaregiverPickerPresented: self.$isCaregiverPickerPresented)
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
                    CategoryLabel(category: .stories)
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
                        Text("Resources")
                            .font(.largeTitle)
                            .bold()

                    case .curriculums:
                        Text("Curriculums")
                            .font(.largeTitle)
                            .bold()

                    case .activities:
                        Text("Activities")
                            .font(.largeTitle)
                            .bold()

                    case .remotes:
                        Text("Remotes")
                            .font(.largeTitle)
                            .bold()

                    case .stories:
                        Text("Stories")
                            .font(.largeTitle)
                            .bold()

                    case .sampleActivities:
                        SampleActivityListView()

                    case .carereceivers:
                        CarereceiverPicker()

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
        // TODO: (@team) - Update this onReceive when caregiver are managed by AccountKit
        .onReceive(self.rootOwnerViewModel.$currentCaregiver) { caregiver in
            if !self.authManagerViewModel.isUserLoggedOut {
                self.isCaregiverPickerPresented = (caregiver == nil)
            }
        }
        .fullScreenCover(isPresented: self.$isCaregiverPickerPresented) {
            CaregiverPicker()
        }
        .fullScreenCover(item: self.$navigation.currentActivity) {
            self.navigation.currentActivity = nil
        } content: { activity in
            ActivityView(activity: activity)
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isSettingsViewPresented) {
            SettingsView()
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isEditCaregiverViewPresented) {
            EditCaregiverView(modifiedCaregiver: self.rootOwnerViewModel.currentCaregiver!)
        }
    }

    // MARK: Private

    @State private var isCaregiverPickerPresented: Bool = false
}

#Preview {
    MainView()
        .previewInterfaceOrientation(.landscapeLeft)
}
