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
                    LibraryCurriculumsView(viewModel: self.libraryManagerViewModel)
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryCurriculums.characters))
                case .libraryStories:
                    LibraryStoriesView(viewModel: self.libraryManagerViewModel)
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryStories.characters))
                default:
                    LibraryActivitiesView(viewModel: self.libraryManagerViewModel)
                        .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryActivities.characters))
            }
        } else {
            Text(String(l10n.MainView.DetailView.disconnectedLibraryMessage.characters))
                .navigationTitle(String(l10n.MainView.Sidebar.sectionLibrary.characters))
        }
    }

    @StateObject private var libraryManagerViewModel = LibraryManagerViewModel() // VM won't work anymore
    @ObservedObject var authManagerViewModel = AuthManagerViewModel.shared
}

#Preview {
    CategoryLibraryView(category: .educationalGames)
}
