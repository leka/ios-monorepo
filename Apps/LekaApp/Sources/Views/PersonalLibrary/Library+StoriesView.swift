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

    init(viewModel: RootAccountManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.stories.isEmpty {
            Text("""
                Your haven't saved any story yet.
                Tap the \(Image(systemName: "ellipsis.circle")) button on any story to add it here.
                You can then remove them from the Library using the same button.
                """)
            .multilineTextAlignment(.center)
        } else {
            ScrollView(showsIndicators: true) {
                StoryListView(stories: self.stories) { story in
                    self.navigation.currentStory = story
                    self.navigation.fullScreenCoverContent = .storyView(carereceivers: [])
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var viewModel: RootAccountManagerViewModel

    private var stories: [Story] {
        self.viewModel.savedStories.compactMap { savedStories in
            ContentKit.allStories.first { $0.id == savedStories.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = RootAccountManagerViewModel()
    NavigationStack {
        LibraryStoriesView(viewModel: viewModel)
    }
}
