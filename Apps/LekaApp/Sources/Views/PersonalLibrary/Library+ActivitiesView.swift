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

    enum SortOption: String, CaseIterable {
        case dateAdded
        case title

        // MARK: Internal

        var label: String {
            switch self {
                case .dateAdded: "Date Added"
                case .title: "Title"
            }
        }
    }

    enum FilterOption: String, CaseIterable {
        case noFilter
        case favorites

        // MARK: Internal

        var label: String {
            switch self {
                case .noFilter: "All"
                case .favorites: "Favorites"
            }
        }
    }

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
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Picker("Sort by", selection: self.$selectedSort) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.label).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle")
                }

                Menu {
                    Picker("Filter", selection: self.$selectedFilter) {
                        ForEach(FilterOption.allCases, id: \.self) { option in
                            Text(option.label).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    // Search, filter & sort
    @State private var searchText: String = ""
    @State private var showSortMenu = false
    @State private var showFilterMenu = false
    @State private var selectedSort: SortOption = .title
    @State private var selectedFilter: FilterOption = .noFilter

    private var viewModel: LibraryManagerViewModel

    private var filteredActivities: [Activity] {
        var results = self.viewModel.activities

        // Filter
        switch self.selectedFilter {
            case .favorites:
                if let caregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                    results = results.filter { $0.favoritedBy.keys.contains(caregiverID) }
                }
            case .noFilter:
                break
        }

        // Map to actual Activities
        var mapped = results.compactMap { savedActivity in
            ContentKit.allPublishedActivities.first { $0.id == savedActivity.id }
        }

        // Sort
        switch self.selectedSort {
            case .dateAdded:
                results.sort {
                    $0.addedAt.compare($1.addedAt) == .orderedAscending
                }
            case .title:
                mapped.sort {
                    $0.details.title.compare($1.details.title, locale: .current) == .orderedAscending
                }
        }

        // Search
        if !self.searchText.isEmpty {
            mapped = mapped.filter {
                $0.details.title.localizedCaseInsensitiveContains(self.searchText)
                    || ($0.details.subtitle?.localizedCaseInsensitiveContains(self.searchText) ?? false)
            }
        }

        return mapped
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    NavigationStack {
        LibraryActivitiesView(viewModel: viewModel)
    }
}
