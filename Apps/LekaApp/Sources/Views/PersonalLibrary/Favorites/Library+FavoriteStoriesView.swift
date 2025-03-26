// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - LibraryStoriesView

struct FavoriteStoriesView: View {
    // MARK: Lifecycle

    init(viewModel: LibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.stories.isEmpty {
            EmptyFavoritesPlaceholderView(icon: .stories)
        } else {
            LibraryStoryListView(stories: self.stories) { story in
                if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                    self.navigation.sheetContent = .carereceiverPicker(activity: nil, story: story)
                } else {
                    self.navigation.currentStory = story
                    self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var viewModel: LibraryManagerViewModel

    private var stories: [Story] {
        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
            self.viewModel.stories.compactMap { savedStory in
                ContentKit.allStories.first {
                    $0.id == savedStory.id && self.viewModel.isStoryFavoritedByCurrentCaregiver(
                        storyID: savedStory.id!,
                        caregiverID: currentCaregiverID
                    )
                }
            }
            .sorted {
                $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
            }
        } else {
            []
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    NavigationStack {
        FavoriteStoriesView(viewModel: viewModel)
    }
}
