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
        if self.items.isEmpty {
            EmptySharedLibraryPlaceholderView(icon: .stories)
        } else {
            VerticalActivityTable(items: self.items)
        }
    }

    // MARK: Private

    private var viewModel: SharedLibraryManagerViewModel

    private var items: [CurationItemModel] {
        self.viewModel.stories.compactMap { savedStories in
            ContentKit.allStories[savedStories.id]
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
        .map { CurationItemModel(id: $0.id, name: $0.name, contentType: .story) }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    NavigationStack {
        SharedLibraryStoriesView(viewModel: viewModel)
    }
}
