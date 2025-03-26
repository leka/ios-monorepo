// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable nesting

extension l10n {
    enum Library {
        enum MenuActions {
            static let addToLibraryButtonLabel = LocalizedString(
                "library.menu_actions.add_to_library_button_label",
                bundle: ContentKitResources.bundle,
                value: "Add to Library",
                comment: "Button label to add an item to the library"
            )

            static let removeFromLibraryButtonLabel = LocalizedString(
                "library.menu_actions.remove_from_library_button_label",
                bundle: ContentKitResources.bundle,
                value: "Remove from Library",
                comment: "Button label to remove an item from the library"
            )

            static let favoriteButtonLabel = LocalizedString(
                "library.menu_actions.favorite_button_label",
                bundle: ContentKitResources.bundle,
                value: "Favorite",
                comment: "Button label to mark an item as favorite"
            )

            static let undoFavoriteButtonLabel = LocalizedString(
                "library.menu_actions.undo_favorite_button_label",
                bundle: ContentKitResources.bundle,
                value: "Undo Favorite",
                comment: "Button label to remove an item from favorites"
            )
        }

        enum Table {
            static let titleColumnLabel = LocalizedString(
                "library.table.title_column_label",
                bundle: ContentKitResources.bundle,
                value: "Title",
                comment: "Title Column header label in the Library table views"
            )
        }
    }
}

// swiftlint:enable nesting
