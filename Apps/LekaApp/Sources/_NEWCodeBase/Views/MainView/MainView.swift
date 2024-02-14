// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

extension Bundle {
    static var version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    static var buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
}

// MARK: - MainView

struct MainView: View {
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
                    CategoryLabel(category: .stories)
                }

                Section(String(l10n.MainView.Sidebar.sectionTracking.characters)) {
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
            .navigationTitle(String(l10n.MainView.Sidebar.navigationTitle.characters))
            .navigationBarTitleDisplayMode(.inline)
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
        .fullScreenCover(isPresented: self.$rootOwnerViewModel.isCaregiverPickerViewPresented) {
            CaregiverPicker()
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isSettingsViewPresented) {
            SettingsView()
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isEditCaregiverViewPresented) {
            EditCaregiverView(modifiedCaregiver: self.rootOwnerViewModel.currentCaregiver!)
        }
    }
}

#Preview {
    MainView()
        .previewInterfaceOrientation(.landscapeLeft)
}
