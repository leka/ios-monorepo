// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - LibraryStoriesView

struct LibraryStoriesView: View {
    // MARK: Lifecycle

    init(viewModel: LibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.stories.isEmpty {
            EmptyLibraryPlaceholderView(icon: .stories)
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
    @ObservedObject private var viewModel: LibraryManagerViewModel
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private var stories: [Story] {
        self.viewModel.stories.compactMap { savedStories in
            ContentKit.allStories.first { $0.id == savedStories.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    NavigationStack {
        LibraryStoriesView(viewModel: viewModel)
    }
}
