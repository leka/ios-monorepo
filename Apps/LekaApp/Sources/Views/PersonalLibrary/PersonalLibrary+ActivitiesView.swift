// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - PersonalLibraryActivitiesView

struct PersonalLibraryActivitiesView: View {
    // MARK: Lifecycle

    init(viewModel: RootAccountManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: true) {
            ActivityGridView(activities: self.activities, onStartActivity: { activity in
                self.navigation.currentActivity = activity
                self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
            })
        }
        .navigationTitle("Personal Library - Activities")
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
        PersonalLibraryActivitiesView(viewModel: viewModel)
    }
}
