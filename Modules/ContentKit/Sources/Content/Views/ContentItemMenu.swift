// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
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
            self.addOrRemoveLibraryButton(self.curationItem, caregiverID: self.caregiverID)
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

    @ObservedObject private var styleManager: StyleManager = .shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    private var libraryManager: LibraryManager = .shared

    private let curationItem: CurationItemModel
    private let caregiverID: String

    @ViewBuilder
    private func addOrRemoveLibraryButton(_ curation: CurationItemModel, caregiverID: String) -> some View {
        let libraryItem = LibraryManager.getLibraryItem(from: curation, caregiverID: caregiverID)

        if self.libraryManagerViewModel.isContentSaved(id: curation.id) {
            Button(role: .destructive) {
                self.libraryManagerViewModel.requestItemRemoval(libraryItem, caregiverID: caregiverID)
            } label: {
                Label(String(l10n.Library.MenuActions.removeFromLibraryButtonLabel.characters), systemImage: "trash")
            }
        } else {
            Button {
                self.libraryManagerViewModel.addItemToLibrary(libraryItem)
            } label: {
                Label(String(l10n.Library.MenuActions.addToLibraryButtonLabel.characters), systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    private func addOrRemoveFavoriteButton(_ curation: CurationItemModel, caregiverID: String) -> some View {
        let libraryItem = LibraryManager.getLibraryItem(from: curation, caregiverID: caregiverID)

        if self.libraryManagerViewModel.isContentFavorited(
            by: caregiverID,
            contentID: curation.id
        ) {
            Button {
                self.libraryManagerViewModel.removeItemFromFavorites(libraryItem)
            } label: {
                Label(String(l10n.Library.MenuActions.undoFavoriteButtonLabel.characters), systemImage: "star.slash")
            }
        } else {
            Button {
                self.libraryManagerViewModel.addItemToFavorite(libraryItem)
            } label: {
                Label(String(l10n.Library.MenuActions.favoriteButtonLabel.characters), systemImage: "star")
            }
        }
    }
}

public extension LibraryManager {
    static func getLibraryItem(from curationItem: CurationItemModel, caregiverID: String) -> AccountKit.LibraryItem {
        var libraryItem: AccountKit.LibraryItem = .activity(SavedActivity(id: "", caregiverID: ""))
        switch curationItem.contentType {
            case .curriculum:
                libraryItem = LibraryItem.curriculum(
                    SavedCurriculum(id: curationItem.id, caregiverID: caregiverID)
                )
            case .activity:
                libraryItem = LibraryItem.activity(
                    SavedActivity(id: curationItem.id, caregiverID: caregiverID)
                )
            case .story:
                libraryItem = LibraryItem.story(
                    SavedStory(id: curationItem.id, caregiverID: caregiverID)
                )
            default:
                logCK.error("Library item conversion - Unsupported content type")
        }
        return libraryItem
    }
}

#Preview {
    ContentItemMenu(
        ContentKit.allCurations[0].sections[0].items[0].curation,
        caregiverID: "Mock UUID"
    )
}
