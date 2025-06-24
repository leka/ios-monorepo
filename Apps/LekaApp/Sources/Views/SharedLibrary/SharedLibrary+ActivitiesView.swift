// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

struct SharedLibraryActivitiesView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.items.isEmpty {
            EmptySharedLibraryPlaceholderView(icon: .activities)
        } else {
            VerticalActivityTable(items: self.items)
        }
    }

    // MARK: Private

    private var viewModel: SharedLibraryManagerViewModel

    private var items: [CurationItemModel] {
        self.viewModel.activities.compactMap { savedActivity in
            ContentKit.allPublishedActivities[savedActivity.id]
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
        .map { CurationItemModel(id: $0.id, name: $0.name, contentType: .activity) }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    NavigationStack {
        SharedLibraryActivitiesView(viewModel: viewModel)
    }
}
