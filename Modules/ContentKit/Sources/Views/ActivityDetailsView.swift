// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import Fit
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
            Section {
                HStack {
                    HStack(alignment: .center) {
                        Image(uiImage: self.activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .center) {
                                Text(self.activity.details.title)
                                    .font(.largeTitle)
                                    .bold()

                                Spacer()

                                VStack {
                                    Image(systemName: "dice")
                                        .font(.title3)
                                    Text(l10n.ActivityDetailsView.activityLabel)
                                        .font(.caption)
                                }
                            }

                            if let subtitle = self.activity.details.subtitle {
                                Text(subtitle)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text(markdown: self.activity.details.shortDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.ActivityDetailsView.skillsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.activity.skills, id: \.self) { skill in
                            TagView(title: skill.name, systemImage: "info.circle") {
                                self.selectedSkill = skill
                            }
                        }
                    }
                    .sheet(item: self.$selectedSkill, onDismiss: { self.selectedSkill = nil }, content: { skill in
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .font(.headline)
                            Text(skill.description)
                        }
                        .padding()
                    })
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.ActivityDetailsView.authorsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.activity.authors, id: \.self) { author in
                            let author = Authors.hmi(id: author)!

                            TagView(title: author.name, systemImage: "info.circle") {
                                self.selectedAuthor = author
                            }
                        }
                    }
                    .sheet(item: self.$selectedAuthor, onDismiss: { self.selectedAuthor = nil }, content: { author in
                        VStack(alignment: .leading) {
                            Text(author.name)
                                .font(.headline)
                            Text(author.description)
                        }
                        .padding()
                    })
                }
            }

            Section(String(l10n.ActivityDetailsView.descriptionSectionTitle.characters)) {
                Markdown(self.activity.details.description)
                    .markdownTheme(.gitHub)
            }

            Section(String(l10n.ActivityDetailsView.instructionsSectionTitle.characters)) {
                Markdown(self.activity.details.instructions)
                    .markdownTheme(.gitHub)
            }
        }
        .toolbar {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ToolbarItemGroup {
                    if self.libraryManagerViewModel.isActivityFavoritedByCurrentCaregiver(
                        activityID: self.activity.id,
                        caregiverID: currentCaregiverID
                    ) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 21))
                            .foregroundColor(self.styleManager.accentColor ?? .blue)
                    }

                    Menu {
                        self.addOrRemoveButton(activity: self.activity, caregiverID: currentCaregiverID)
                        Divider()
                        self.addOrRemoveFavoriteButton(activity: self.activity, caregiverID: currentCaregiverID)
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

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?

    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared
    private let activity: Activity

    @ViewBuilder
    private func addOrRemoveButton(activity: Activity, caregiverID: String) -> some View {
        let libraryItem = LibraryItem.activity(
            SavedActivity(id: activity.uuid, caregiverID: caregiverID)
        )

        if self.libraryManagerViewModel.isActivitySaved(activityID: activity.uuid) {
            Button(role: .destructive) {
                self.libraryManagerViewModel.requestItemRemoval(libraryItem, caregiverID: caregiverID)
            } label: {
                Label(String(l10n.Library.MenuActions.removeFromLibraryButtonLabel.characters), systemImage: "trash")
            }
        } else {
            Button {
                self.libraryManager.addActivity(
                    activityID: activity.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label(String(l10n.Library.MenuActions.addToLibraryButtonLabel.characters), systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    private func addOrRemoveFavoriteButton(activity: Activity, caregiverID: String) -> some View {
        if self.libraryManagerViewModel.isActivityFavoritedByCurrentCaregiver(
            activityID: activity.uuid,
            caregiverID: caregiverID
        ) {
            Button {
                self.libraryManager.removeActivityFromFavorites(
                    activityID: activity.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label(String(l10n.Library.MenuActions.undoFavoriteButtonLabel.characters), systemImage: "star.slash")
            }
        } else {
            Button {
                self.libraryManager.addActivityToLibraryAsFavorite(
                    activityID: activity.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label(String(l10n.Library.MenuActions.favoriteButtonLabel.characters), systemImage: "star")
            }
        }
    }
}

// MARK: - l10n.ActivityDetailsView

extension l10n {
    enum ActivityDetailsView {
        static let activityLabel = LocalizedString("content_kit.activity_details_view.activity_label",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Activity",
                                                   comment: "ActivityDetailsView's content type description label")

        static let skillsSectionTitle = LocalizedString("content_kit.activity_details_view.skills_section_title",
                                                        bundle: ContentKitResources.bundle,
                                                        value: "Skills",
                                                        comment: "ActivityDetailsView 'skills' section title")

        static let authorsSectionTitle = LocalizedString("content_kit.activity_details_view.authors_section_title",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Authors",
                                                         comment: "ActivityDetailsView 'authors' section title")

        static let descriptionSectionTitle = LocalizedString("content_kit.activity_details_view.description_section_title",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Description",
                                                             comment: "ActivityDetailsView 'description' section title")

        static let instructionsSectionTitle = LocalizedString("content_kit.activity_details_view.instructions_section_title",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Instructions",
                                                              comment: "ActivityDetailsView 'instructions' section title")

        static let startActivityButtonLabel = LocalizedString("content_kit.activity_details_view.start_activity_button_label",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Start activity",
                                                              comment: "Start activity button label on Activity Details view")
    }
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}
