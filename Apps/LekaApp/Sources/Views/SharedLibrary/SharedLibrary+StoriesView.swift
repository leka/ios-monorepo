// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct SharedLibraryStoriesView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.stories.isEmpty {
            EmptySharedLibraryPlaceholderView(icon: .stories)
        } else {
            SharedLibraryStoryListView(stories: self.stories) { story in
                if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                    self.navigation.setSheetContent(.carereceiverPicker(activity: nil, story: story))
                } else {
                    self.navigation.setCurrentStory(story)
                    self.navigation.setFullScreenCoverContent(.activityView(carereceivers: []))
                }
            }
        }
    }

    // MARK: Private

    private var navigation: Navigation = .shared
    private var viewModel: SharedLibraryManagerViewModel
    private var authManagerViewModel: AuthManagerViewModel = .shared

    private var stories: [Story] {
        self.viewModel.stories.compactMap { savedStories in
            ContentKit.allStories[savedStories.id]
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    NavigationStack {
        SharedLibraryStoriesView(viewModel: viewModel)
    }
}
