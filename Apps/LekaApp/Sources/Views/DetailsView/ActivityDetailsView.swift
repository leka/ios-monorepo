// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import DesignKit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - ActivityDetailsView

public struct ActivityDetailsView: View {
    // MARK: Lifecycle

    public init(activity: Activity, onStartActivity: ((Activity) -> Void)? = nil) {
        self.activity = activity
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        List {
            InfoDetailsView(CurationItemModel(id: self.activity.id, name: self.activity.name, contentType: .activity))

            Section(String(l10n.ActivityDetailsView.instructionsSectionTitle.characters)) {
                Markdown(self.activity.details.instructions)
            }

            if self.activity.curriculums.isNotEmpty {
                Section(String(l10n.ActivityDetailsView.relatedCurriculumSectionTitle.characters)) {
                    HorizontalCurriculumGrid(items: self.activity.curriculums.map {
                        CurationItemModel(id: $0, name: "", contentType: .curriculum)
                    })
                }
            }
        }
        .toolbar {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Add to Library button
                    let libraryItem = SharedLibraryManager.getSharedLibraryItem(from: CurationItemModel(id: self.activity.id, name: self.activity.name, contentType: .activity), caregiverID: currentCaregiverID)
                    if self.sharedLibraryManagerViewModel.isContentSaved(id: self.activity.id) {
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
                    if self.sharedLibraryManagerViewModel.isContentFavorited(by: currentCaregiverID, contentID: self.activity.id) {
                        Button {
                            self.sharedLibraryManagerViewModel.removeItemFromFavorites(libraryItem)
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
                        CurationItemModel(id: self.activity.id, name: self.activity.name, contentType: .activity),
                        caregiverID: currentCaregiverID
                    )
                }
            }

            ToolbarItem {
                Button {
                    self.onStartActivity?(self.activity)
                    AnalyticsManager.logEventActivityLaunch(id: self.activity.id, name: self.activity.name, origin: .detailsViewButton)
                } label: {
                    Image(systemName: "play.fill")
                    Text(l10n.ActivityDetailsView.startActivityButtonLabel)
                }
                .buttonStyle(.borderedProminent)
                .tint(.lkGreen)
                .disabled(self.onStartActivity == nil)
                .opacity(self.onStartActivity == nil ? 0 : 1)
            }
        }
    }

    // MARK: Internal

    var onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared

    private let activity: Activity
}

// MARK: - l10n.ActivityDetailsView

extension l10n {
    enum ActivityDetailsView {
        static let startActivityButtonLabel = LocalizedString("lekaapp.activity_details_view.start_activity_button_label",
                                                              value: "Start activity",
                                                              comment: "Start activity button label on Activity Details view")

        static let instructionsSectionTitle = LocalizedString("lekaapp.activity_details_view.instructions_section_title",
                                                              value: "Instructions",
                                                              comment: "ActivityDetailsView 'instructions' section title")

        static let relatedCurriculumSectionTitle = LocalizedString("lekaapp.activity_details_view.related_curriculum_section_title",
                                                                   value: "Related Curriculums",
                                                                   comment: "ActivityDetailsView 'related curriculum' section title")
    }
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}
