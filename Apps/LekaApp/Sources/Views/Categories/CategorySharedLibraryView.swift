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
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryCurriculums.characters))
                    case .sharedLibraryStories:
                        SharedLibraryStoriesView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryStories.characters))
                    case .sharedLibraryActivities:
                        SharedLibraryActivitiesView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryActivities.characters))
                    default:
                        SharedLibraryFavoritesView(viewModel: self.sharedLibraryManagerViewModel)
                            .navigationTitle(String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryFavorites.characters))
                }
            }
        } else {
            Text(String(l10n.MainView.DetailView.disconnectedSharedLibraryMessage.characters))
                .navigationTitle(String(l10n.MainView.Sidebar.sectionSharedLibrary.characters))
        }
    }
}

#Preview {
    CategorySharedLibraryView(category: .educationalGames)
}
