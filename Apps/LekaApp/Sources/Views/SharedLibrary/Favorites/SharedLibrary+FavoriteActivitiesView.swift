// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - FavoriteActivitiesView

struct FavoriteActivitiesView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.items.isEmpty {
            EmptyFavoritesPlaceholderView(icon: .activities)
        } else {
            VerticalActivityTable(items: self.items)
        }
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var viewModel: SharedLibraryManagerViewModel

    private var items: [CurationItemModel] {
        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
            self.viewModel.activities.compactMap { savedActivity in
                guard self.viewModel.isActivityFavoritedByCurrentCaregiver(
                    activityID: savedActivity.id,
                    caregiverID: currentCaregiverID
                ), let activity = ContentKit.allPublishedActivities[savedActivity.id] else {
                    return nil
                }
                return CurationItemModel(id: activity.id, name: activity.name, contentType: .activity)
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
        FavoriteActivitiesView(viewModel: viewModel)
    }
}
