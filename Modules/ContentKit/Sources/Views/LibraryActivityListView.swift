// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - LibraryActivityListView

public struct LibraryActivityListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        Table(self.activities) {
            TableColumn("Title") { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                        .logEventScreenView(
                            screenName: "activity_details",
                            context: .splitView,
                            parameters: ["lk_activity_id": "\(activity.name)-\(activity.id)"]
                        )
                ) {
                    HStack(spacing: 10) {
                        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id, self.libraryManagerViewModel
                            .isActivityFavoritedByCurrentCaregiver(
                                activityID: activity.id,
                                caregiverID: currentCaregiverID
                            )
                        {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(self.styleManager.accentColor ?? .blue)
                                .frame(width: 10)
                        } else {
                            Color.clear
                                .frame(width: 10)
                        }

                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(activity.details.title)
                                .font(.headline)

                            if let subtitle = activity.details.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                            }
                        }

                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .width(min: 400, ideal: 450, max: .infinity)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getGestureIconUIImage(for: activity))
            }
            .width(50)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .ears))
            }
            .width(50)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .robot))
            }
            .width(50)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getTemplateIconUIImage(for: activity))
            }
            .width(50)

            #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                TableColumn("") { activity in
                    if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                        Menu {
                            self.addOrRemoveButton(activity: activity, caregiverID: currentCaregiverID)
                            Divider()
                            self.addOrRemoveFavoriteButton(activity: activity, caregiverID: currentCaregiverID)
                        } label: {
                            Image(systemName: "ellipsis")
                                .bold()
                        }
                        .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                    }
                }
                .width(50)
            #endif

            TableColumn("") { activity in
                Button {
                    self.onStartActivity?(activity)
                    AnalyticsManager.logEventActivityLaunch(id: activity.id, name: activity.name, origin: .listButton)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text(l10n.LibraryActivityListView.playButtonLabel)
                            .font(.callout)
                    }
                    .foregroundColor(.lkGreen)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .overlay(
                        Capsule()
                            .stroke(Color.lkGreen, lineWidth: 1)
                    )
                }
            }
            .width(80)
        }
        .tableStyle(.inset)
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    private struct IconImageView: View {
        let image: UIImage?

        var body: some View {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.secondary)
                    .scaledToFit()
                    .frame(width: 50)
                    .padding(.horizontal, 5)
            } else {
                Color.clear
                    .frame(width: 50, height: 50)
            }
        }
    }

    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared

    @ViewBuilder
    private func addOrRemoveButton(activity: Activity, caregiverID: String) -> some View {
        let libraryItem = LibraryItem.activity(
            SavedActivity(id: activity.uuid, caregiverID: caregiverID)
        )

        if self.libraryManagerViewModel.isActivitySaved(activityID: activity.uuid) {
            Button(role: .destructive) {
                self.libraryManagerViewModel.requestItemRemoval(libraryItem, caregiverID: caregiverID)
            } label: {
                Label("Remove from Library", systemImage: "trash")
            }
        } else {
            Button {
                self.libraryManager.addActivity(
                    activityID: activity.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Add to Library", systemImage: "plus")
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
                Label("Undo Favorite", systemImage: "star.slash")
            }
        } else {
            Button {
                self.libraryManager.addActivityToLibraryAsFavorite(
                    activityID: activity.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Favorite", systemImage: "star")
            }
        }
    }
}

// MARK: - l10n.LibraryActivityListView

extension l10n {
    enum LibraryActivityListView {
        static let playButtonLabel = LocalizedString("content_kit.library_activity_list_view.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Play",
                                                     comment: "Play button label on Library Activity List view")
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            LibraryActivityListView(
                activities: ContentKit.allActivities,
                onStartActivity: { _ in
                    print("Activity Started")
                }
            )
        }
    }
}
