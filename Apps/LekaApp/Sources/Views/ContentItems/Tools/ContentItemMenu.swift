// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ContentItemMenu

public struct ContentItemMenu: View {
    // MARK: Lifecycle

    public init(_ curationItem: CurationItemModel, caregiverID: String) {
        self.curationItem = curationItem
        self.caregiverID = caregiverID
    }

    // MARK: Public

    public var body: some View {
        Menu {
            self.addOrRemoveSharedLibraryButton(self.curationItem, caregiverID: self.caregiverID)
            Divider()
            self.addOrRemoveFavoriteButton(self.curationItem, caregiverID: self.caregiverID)
        } label: {
            Button {
                // Nothing to do
            } label: {
                Image(systemName: "ellipsis")
                    .bold()
            }
            .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
        }
    }

    // MARK: Private

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared

    private let curationItem: CurationItemModel
    private let caregiverID: String

    @ViewBuilder
    private func addOrRemoveSharedLibraryButton(_ curation: CurationItemModel, caregiverID: String) -> some View {
        let libraryItem = SharedLibraryManager.getSharedLibraryItem(from: curation, caregiverID: caregiverID)

        if self.sharedLibraryManagerViewModel.isContentSaved(id: curation.id) {
            Button(role: .destructive) {
                self.sharedLibraryManagerViewModel.requestItemRemoval(libraryItem, name: curation.name, caregiverID: caregiverID)
            } label: {
                Label(String(l10n.ContentItemMenu.removeFromSharedLibraryButtonLabel.characters), systemImage: "trash")
            }
        } else {
            Button {
                self.sharedLibraryManagerViewModel.addItemToSharedLibrary(libraryItem, name: curation.name)
            } label: {
                Label(String(l10n.ContentItemMenu.addToSharedLibraryButtonLabel.characters), systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    private func addOrRemoveFavoriteButton(_ curation: CurationItemModel, caregiverID: String) -> some View {
        let libraryItem = SharedLibraryManager.getSharedLibraryItem(from: curation, caregiverID: caregiverID)

        if self.sharedLibraryManagerViewModel.isContentFavorited(
            by: caregiverID,
            contentID: curation.id
        ) {
            Button {
                self.sharedLibraryManagerViewModel.removeItemFromFavorites(libraryItem, name: curation.name, caregiverID: caregiverID)
            } label: {
                Label(String(l10n.ContentItemMenu.undoFavoriteButtonLabel.characters), systemImage: "star.slash")
            }
        } else {
            Button {
                self.sharedLibraryManagerViewModel.addItemToFavorite(libraryItem, name: curation.name)
            } label: {
                Label(String(l10n.ContentItemMenu.favoriteButtonLabel.characters), systemImage: "star")
            }
        }
    }
}

public extension SharedLibraryManager {
    static func getSharedLibraryItem(from curationItem: CurationItemModel, caregiverID: String) -> AccountKit.SharedLibraryItem {
        var libraryItem: AccountKit.SharedLibraryItem = .activity(SavedActivity(id: "", caregiverID: ""))
        switch curationItem.contentType {
            case .curriculum:
                libraryItem = SharedLibraryItem.curriculum(
                    SavedCurriculum(id: curationItem.id, caregiverID: caregiverID)
                )
            case .activity:
                libraryItem = SharedLibraryItem.activity(
                    SavedActivity(id: curationItem.id, caregiverID: caregiverID)
                )
            case .story:
                libraryItem = SharedLibraryItem.story(
                    SavedStory(id: curationItem.id, caregiverID: caregiverID)
                )
            default:
                log.error("Shared Library item conversion - Unsupported content type")
        }
        return libraryItem
    }
}

// MARK: - l10n.ContentItemMenu

extension l10n {
    enum ContentItemMenu {
        static let addToSharedLibraryButtonLabel = LocalizedString(
            "lekaapp.content_item_menu.add_to_shared_library_button_label",
            value: "Add to Shared Library",
            comment: "Button label to add an item to the shared library"
        )

        static let removeFromSharedLibraryButtonLabel = LocalizedString(
            "lekaapp.content_item_menu.remove_from_shared_library_button_label",
            value: "Remove from Shared Library",
            comment: "Button label to remove an item from the shared library"
        )

        static let favoriteButtonLabel = LocalizedString(
            "lekaapp.content_item_menu.favorite_button_label",
            value: "Favorite",
            comment: "Button label to mark an item as favorite"
        )

        static let undoFavoriteButtonLabel = LocalizedString(
            "lekaapp.content_item_menu.undo_favorite_button_label",
            value: "Undo Favorite",
            comment: "Button label to remove an item from favorites"
        )
    }
}

#Preview {
    ContentItemMenu(
        ContentKit.allCurations.first!.value.sections[0].items[0],
        caregiverID: "Mock UUID"
    )
}
