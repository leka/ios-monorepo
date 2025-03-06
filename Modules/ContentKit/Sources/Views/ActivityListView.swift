// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ActivityListView

public struct ActivityListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        ScrollView {
            Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 24) {
                ForEach(self.activities) { activity in
                    GridRow {
                        NavigationLink(destination:
                            ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                                .logEventScreenView(
                                    screenName: "activity_details",
                                    context: .splitView,
                                    parameters: ["lk_activity_id": "\(activity.name)-\(activity.id)"]
                                )
                        ) {
                            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
                               self.libraryManagerViewModel.isActivityFavoritedByCurrentCaregiver(
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

                            HStack(spacing: 10) {
                                Image(uiImage: activity.details.iconImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 50)
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())

                            if let gestureIconUIImage = ContentKit.getGestureIconUIImage(for: activity) {
                                IconImageView(image: gestureIconUIImage)
                            }

                            if let earFocusIconUIImage = ContentKit.getFocusIconUIImage(for: activity, ofType: .ears) {
                                IconImageView(image: earFocusIconUIImage)
                            }

                            if let robotFocusIconUIImage = ContentKit.getFocusIconUIImage(for: activity, ofType: .robot) {
                                IconImageView(image: robotFocusIconUIImage)
                            }

                            if let templateIconUIImage = ContentKit.getTemplateIconUIImage(for: activity) {
                                IconImageView(image: templateIconUIImage)
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, maxHeight: 120)
                        .simultaneousGesture(TapGesture().onEnded {
                            AnalyticsManager.logEventSelectContent(
                                type: .activity,
                                id: activity.id,
                                name: activity.name,
                                origin: .generalLibrary
                            )
                        })

                        #if DEVELOPER_MODE || TESTFLIGHT_BUILD
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
                                .frame(width: 50)
                            }
                        #endif

                        Button {
                            self.onStartActivity?(activity)
                            AnalyticsManager.logEventActivityLaunch(id: activity.id, name: activity.name, origin: .listButton)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "play.fill")
                                Text(l10n.ActivityListView.playButtonLabel)
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
                }
            }
            .padding()
        }
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

// MARK: - l10n.ActivityListView

extension l10n {
    enum ActivityListView {
        static let playButtonLabel = LocalizedString("content_kit.activity_list_view.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Play",
                                                     comment: "Play button label on Activity List view")
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            ScrollView {
                ActivityListView(
                    activities: ContentKit.allActivities,
                    onStartActivity: { _ in
                        print("Activity Started")
                    }
                )
            }
        }
    }
}
