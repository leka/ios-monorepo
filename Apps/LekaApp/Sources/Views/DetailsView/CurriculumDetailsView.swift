// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import Fit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - CurriculumDetailsView

public struct CurriculumDetailsView: View {
    // MARK: Lifecycle

    public init(curriculum: Curriculum) {
        self.curriculum = curriculum
    }

    // MARK: Public

    public var body: some View {
        List {
            InfoDetailsView(CurationItemModel(id: self.curriculum.id, name: self.curriculum.name, contentType: .curriculum))

            Section(String(l10n.CurriculumDetailsView.activitiesSectionTitle.characters)) {
                ScrollView(showsIndicators: true) {
                    VerticalActivityList(items:
                        self.curriculum.activities.compactMap {
                            guard let activity = Activity(id: $0) else { return nil }
                            return CurationItemModel(id: activity.id, name: activity.name, contentType: .activity)
                        }
                    )
                }
            }
        }
        .toolbar {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Add to Library button
                    let libraryItem = SharedLibraryManager.getSharedLibraryItem(from: CurationItemModel(id: self.curriculum.uuid, name: self.curriculum.name, contentType: .curriculum), caregiverID: currentCaregiverID)
                    if self.sharedLibraryManagerViewModel.isContentSaved(id: self.curriculum.uuid) {
                        Button(role: .destructive) {
                            self.sharedLibraryManagerViewModel.requestItemRemoval(libraryItem, caregiverID: currentCaregiverID)
                        } label: {
                            Label(String(l10n.ContentItemMenu.removeFromSharedLibraryButtonLabel.characters), systemImage: "trash")
                        }
                    } else {
                        Button {
                            self.sharedLibraryManagerViewModel.addItemToSharedLibrary(libraryItem)
                        } label: {
                            Label(String(l10n.ContentItemMenu.addToSharedLibraryButtonLabel.characters), systemImage: "plus")
                        }
                    }

                    // Favorite button (star/star.fill)
                    if self.sharedLibraryManagerViewModel.isContentFavorited(by: currentCaregiverID, contentID: self.curriculum.uuid) {
                        Button {
                            self.sharedLibraryManagerViewModel.removeItemFromFavorites(libraryItem, caregiverID: currentCaregiverID)
                        } label: {
                            Label(String(l10n.ContentItemMenu.undoFavoriteButtonLabel.characters), systemImage: "star.fill")
                        }
                    } else {
                        Button {
                            self.sharedLibraryManagerViewModel.addItemToFavorite(libraryItem)
                        } label: {
                            Label(String(l10n.ContentItemMenu.favoriteButtonLabel.characters), systemImage: "star")
                        }
                    }

                    // 3 dots menu
                    ContentItemMenu(
                        CurationItemModel(id: self.curriculum.uuid, name: self.curriculum.name, contentType: .curriculum),
                        caregiverID: currentCaregiverID
                    )
                }
            }
        }
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared
    private let curriculum: Curriculum
}

// MARK: - l10n.CurriculumDetailsView

extension l10n {
    enum CurriculumDetailsView {
        static let activitiesSectionTitle = LocalizedString("lekaapp.curriculum_details_view.activities_section_title",
                                                            value: "Activities",
                                                            comment: "CurriculumDetailsView 'activities' section title")
    }
}

#Preview {
    NavigationStack {
        CurriculumDetailsView(curriculum: Curriculum.mock)
    }
}
