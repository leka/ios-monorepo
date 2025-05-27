// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct CategorySharedLibraryView: View {
    @State var category: Navigation.Category

    @State var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared

    var authManagerViewModel: AuthManagerViewModel = .shared

    var body: some View {
        if self.authManagerViewModel.userAuthenticationState == .loggedIn {
            Group {
                switch self.category {
                    case .sharedLibraryCurriculums:
                        SharedLibraryCurriculumsView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryCurriculums.characters))
                    case .sharedLibraryStories:
                        SharedLibraryStoriesView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryStories.characters))
                    case .sharedLibraryActivities:
                        SharedLibraryActivitiesView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryActivities.characters))
                    default:
                        SharedLibraryFavoritesView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.libraryFavorites.characters))
                }
            }
        } else {
            Text(String(l10n.MainView.DetailView.disconnectedLibraryMessage.characters))
                .navigationTitle(String(l10n.MainView.Sidebar.sectionLibrary.characters))
        }
    }
}

#Preview {
    CategorySharedLibraryView(category: .educationalGames)
}
