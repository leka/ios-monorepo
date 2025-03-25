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
            if self.filteredItems.isEmpty {
                EmptySharedLibraryPlaceholderView(icon: .activities)
            } else {
                VerticalActivityTable(items: self.filteredItems)
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

    @State private var searchText: String = ""
    @State private var showSortMenu = false
    @State private var showFilterMenu = false
    @State private var selectedSort: SortOption = .title
    @State private var selectedFilter: FilterOption = .noFilter

    private var viewModel: SharedLibraryManagerViewModel
    private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var filteredItems: [CurationItemModel] {
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
            ContentKit.allPublishedActivities.first(where: { $0.key == savedActivity.id })?.value
        }

        // Sort
        switch self.selectedSort {
            case .dateAdded:
                results.sort {
                    $0.addedAt.compare($1.addedAt) == .orderedAscending
                }
            case .title:
                mapped.sort {
                    $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
                }
        }

        // Search
        if !self.searchText.isEmpty {
            mapped = mapped.filter {
                $0.details.title.localizedCaseInsensitiveContains(self.searchText)
                    || ($0.details.subtitle?.localizedCaseInsensitiveContains(self.searchText) ?? false)
            }
        }

        // Map to CurationItemModel items
        let mappedItems = mapped.map { CurationItemModel(id: $0.id, name: $0.name, contentType: .activity) }

        return mappedItems
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    NavigationStack {
        SharedLibraryActivitiesView(viewModel: viewModel)
    }
}
