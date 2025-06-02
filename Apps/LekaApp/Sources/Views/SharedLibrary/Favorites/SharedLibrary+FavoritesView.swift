// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - SharedLibraryFavoritesView

struct SharedLibraryFavoritesView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        VStack {
            Picker("Favorites", selection: self.$selectedCategory) {
                ForEach(FavoriteCategory.allCases, id: \..self) { category in
                    Text(category.localizedName).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 400)

            Spacer()

            self.contentView(for: self.selectedCategory)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding()

            Spacer()
        }
    }

    // MARK: Private

    @State private var selectedCategory: FavoriteCategory = .activities

    private var viewModel: SharedLibraryManagerViewModel

    @ViewBuilder
    private func contentView(for category: FavoriteCategory) -> some View {
        switch category {
            case .activities:
                FavoriteActivitiesView(viewModel: self.viewModel)
            case .curriculums:
                FavoriteCurriculumsView(viewModel: self.viewModel)
            case .stories:
                FavoriteStoriesView(viewModel: self.viewModel)
        }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    NavigationStack {
        SharedLibraryFavoritesView(viewModel: viewModel)
    }
}

// MARK: - FavoriteCategory

enum FavoriteCategory: String, CaseIterable {
    case activities
    case curriculums
    case stories

    // MARK: Internal

    var localizedName: String {
        switch self {
            case .activities:
                String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryActivities.characters)
            case .curriculums:
                String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryCurriculums.characters)
            case .stories:
                String(l10n.MainView.Sidebar.CategoryLabel.sharedLibraryStories.characters)
        }
    }
}
