// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - PersonalLibraryActivitiesView

struct FavoriteActivitiesView: View {
    // MARK: Lifecycle

    init(viewModel: LibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.activities.isEmpty {
            EmptyLibraryPlaceholderView(icon: .activities)
        } else {
            ScrollView(showsIndicators: true) {
                LibraryActivityListView(activities: self.activities) { activity in
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                        self.navigation.sheetContent = .carereceiverPicker(activity: activity, story: nil)
                    } else {
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                    }
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var viewModel: LibraryManagerViewModel
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private var activities: [Activity] {
        self.viewModel.favoriteActivities.compactMap { favoriteActivity in
            ContentKit.allPublishedActivities.first { $0.id == favoriteActivity.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    NavigationStack {
        FavoriteActivitiesView(viewModel: viewModel)
    }
}
