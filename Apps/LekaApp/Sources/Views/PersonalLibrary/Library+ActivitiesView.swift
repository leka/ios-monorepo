// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - PersonalLibraryActivitiesView

struct LibraryActivitiesView: View {
    // MARK: Lifecycle

    init(viewModel: RootAccountManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.activities.isEmpty {
            EmptyLibraryPlaceholderView(icon: .activities)
        } else {
            ScrollView(showsIndicators: true) {
                ActivityListView(activities: self.activities) { activity in
                    self.navigation.currentActivity = activity
                    self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var viewModel: RootAccountManagerViewModel

    private var activities: [Activity] {
        self.viewModel.savedActivities.compactMap { savedActivity in
            ContentKit.allPublishedActivities.first { $0.id == savedActivity.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = RootAccountManagerViewModel()
    NavigationStack {
        LibraryActivitiesView(viewModel: viewModel)
    }
}
