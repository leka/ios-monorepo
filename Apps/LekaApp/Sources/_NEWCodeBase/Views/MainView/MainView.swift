// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - MainView

struct MainView: View {
    @EnvironmentObject var styleManager: StyleManager

    @ObservedObject var navigation: Navigation = .shared
    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        NavigationSplitView {
            List(selection: self.$navigation.selectedCategory) {
                HStack {
                    Spacer()
                    LekaLogo(width: 80)
                    Spacer()
                }

                // TODO: (@ladislas) move insets to button view
                GoToRobotConnectButton()
                    .listRowInsets(EdgeInsets(top: -5, leading: -20, bottom: -15, trailing: -20))

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
            }
            // TODO: (@ladislas) remove if not necessary
            // .disabled(navigation.disableUICompletly)
            .navigationTitle(String(l10n.MainView.Sidebar.navigationTitle.characters))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.styleManager.toggleAccentColor()
                    } label: {
                        Image(systemName: "eyedropper")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.styleManager.toggleColorScheme()
                    } label: {
                        Image(systemName: "circle.lefthalf.filled")
                    }
                }
            }
        } detail: {
            NavigationStack(path: self.$navigation.path) {
                switch self.navigation.selectedCategory {
                    case .news:
                        Text("Hello, What's new!")
                            .font(.largeTitle)
                            .bold()

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
    }
}

#Preview {
    MainView()
        .previewInterfaceOrientation(.landscapeLeft)
        .environmentObject(StyleManager())
}
