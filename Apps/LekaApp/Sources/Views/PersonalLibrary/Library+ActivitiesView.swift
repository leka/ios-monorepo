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

    init(viewModel: LibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        Group {
            if self.filteredActivities.isEmpty {
                EmptyLibraryPlaceholderView(icon: .activities)
            } else {
                LibraryActivityListView(activities: self.filteredActivities) { activity in
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                        self.navigation.sheetContent = .carereceiverPicker(activity: activity, story: nil)
                    } else {
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                    }
                }
            }
        }
        .searchable(
            text: self.$searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text(String(localized: "Search"))
        )
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    @State private var searchText: String = ""

    private var viewModel: LibraryManagerViewModel

    private var activities: [Activity] {
        self.viewModel.activities.compactMap { savedActivity in
            ContentKit.allPublishedActivities.first { $0.id == savedActivity.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }

    private var filteredActivities: [Activity] {
        guard !self.searchText.isEmpty else { return self.activities }

        return self.activities.filter {
            $0.details.title.localizedCaseInsensitiveContains(self.searchText)
                || ($0.details.subtitle?.localizedCaseInsensitiveContains(self.searchText) ?? false)
                || ($0.details.instructions.localizedCaseInsensitiveContains(self.searchText))
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    NavigationStack {
        LibraryActivitiesView(viewModel: viewModel)
    }
}
