// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct CategoryLibraryView: View {
    @State var category: Navigation.Category

    var body: some View {
        if self.authManagerViewModel.userAuthenticationState == .loggedIn {
            switch self.category {
                case .libraryCurriculums:
                    LibraryCurriculumsView(viewModel: self.rootAccountViewModel)
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.curriculums.characters))
                case .libraryStories:
                    LibraryStoriesView(viewModel: self.rootAccountViewModel)
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.stories.characters))
                case .libraryGamepads:
                    LibraryGamepadsView()
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.gamepads.characters))
                default:
                    LibraryActivitiesView(viewModel: self.rootAccountViewModel)
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.activities.characters))
            }
        } else {
            Text(String(l10n.MainView.DetailView.disconnectedLibraryMessage.characters))
                .navigationTitle(String(l10n.MainView.Sidebar.sectionLibrary.characters))
        }
    }

    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()
    @ObservedObject var authManagerViewModel = AuthManagerViewModel.shared
}

#Preview {
    CategoryLibraryView(category: .activities)
}
