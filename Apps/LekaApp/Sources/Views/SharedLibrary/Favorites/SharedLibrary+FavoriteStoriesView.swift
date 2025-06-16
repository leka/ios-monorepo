// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - FavoriteStoriesView

struct FavoriteStoriesView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.items.isEmpty {
            EmptyFavoritesPlaceholderView(icon: .stories)
        } else {
            VerticalActivityTable(items: self.items)
        }
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var viewModel: SharedLibraryManagerViewModel

    private var items: [CurationItemModel] {
        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
            self.viewModel.stories.compactMap { savedStory in
                guard self.viewModel.isStoryFavoritedByCurrentCaregiver(
                    storyID: savedStory.id,
                    caregiverID: currentCaregiverID
                ), let story = ContentKit.allStories[savedStory.id] else {
                    return nil
                }
                return CurationItemModel(id: story.id, name: story.name, contentType: .story)
            }
            .sorted {
                $0.name.compare($1.name, locale: NSLocale.current) == .orderedAscending
            }
        } else {
            []
        }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    NavigationStack {
        FavoriteStoriesView(viewModel: viewModel)
    }
}
