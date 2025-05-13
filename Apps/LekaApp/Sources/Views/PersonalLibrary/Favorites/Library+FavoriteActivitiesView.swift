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
            EmptyFavoritesPlaceholderView(icon: .activities)
        } else {
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

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var viewModel: LibraryManagerViewModel

    private var activities: [Activity] {
        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
            self.viewModel.activities.compactMap { savedActivity in
                guard self.viewModel.isActivityFavoritedByCurrentCaregiver(
                    activityID: savedActivity.id,
                    caregiverID: currentCaregiverID
                ) else {
                    return nil
                }
                return ContentKit.allPublishedActivities[savedActivity.id]
            }
            .sorted {
                $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
            }
        } else {
            []
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    NavigationStack {
        FavoriteActivitiesView(viewModel: viewModel)
    }
}
