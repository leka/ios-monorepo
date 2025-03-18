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
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(self.activities) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                        .logEventScreenView(
                            screenName: "activity_details",
                            context: .splitView,
                            parameters: [
                                "lk_activity_id": "\(activity.name)-\(activity.id)",
                            ]
                        )

                ) {
                    HStack(alignment: .center) {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            HStack {
                                Text(activity.details.title)
                                    .font(.headline)
                                    .frame(alignment: .leading)
                            }

                            if let subtitle = activity.details.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                                    .frame(alignment: .leading)
                            }
                        }
                        .padding(.vertical)

                        Spacer()

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

                        #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                                Button {} label: {
                                    Menu {
                                        if self.libraryManagerViewModel.isActivitySaved(activityID: activity.uuid) {
                                            Button(role: .destructive) {
                                                self.libraryManager.removeActivity(activityID: activity.uuid)
                                            } label: {
                                                Label(String(l10n.Library.MenuActions.removeFromlibraryButtonLabel.characters), systemImage: "trash")
                                            }
                                        } else {
                                            Button {
                                                self.libraryManager.addActivity(
                                                    activityID: activity.uuid,
                                                    caregiverID: currentCaregiverID
                                                )
                                            } label: {
                                                Label(String(l10n.Library.MenuActions.addTolibraryButtonLabel.characters), systemImage: "plus")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .bold()
                                    }
                                    .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                                }
                            }
                        #endif

                        Button {
                            self.onStartActivity?(activity)
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
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .contentShape(Rectangle())
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.logEventSelectContent(
                        type: .activity,
                        id: activity.id,
                        name: activity.name,
                        origin: .generalLibrary
                    )
                })
                .buttonStyle(.plain)
            }
        }
        .padding()
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    private struct IconImageView: View {
        let image: UIImage?

        var body: some View {
            Image(uiImage: self.image ?? UIImage())
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.primary)
                .scaledToFit()
                .frame(width: 50)
                .padding(.horizontal, 5)
        }
    }

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var libraryManagerViewModel = LibraryManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared
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
