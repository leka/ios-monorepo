// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
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
                                Button {
                                    if self.rootAccountViewModel.isActivitySaved(activityID: activity.uuid) {
                                        self.rootAccountViewModel.removeSavedActivity(activityID: activity.uuid)
                                    } else {
                                        self.rootAccountViewModel.addSavedActivity(
                                            activityID: activity.uuid,
                                            caregiverID: currentCaregiverID
                                        )
                                    }
                                } label: {
                                    if self.rootAccountViewModel.isActivitySaved(activityID: activity.uuid) {
                                        Image(systemName: "trash")
                                    } else {
                                        Image(systemName: "plus")
                                    }
                                }
                                .tint(self.rootAccountViewModel.isActivitySaved(activityID: activity.uuid) ? .red : self.styleManager.accentColor!)
                            }
                        #endif

                        Button {
                            self.onStartActivity?(activity)
                        } label: {
                            Image(systemName: "play.circle")
                                .font(.system(size: 24))
                                .contentShape(Rectangle())
                        }
                        .tint(.lkGreen)
                        .padding(.horizontal, 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .contentShape(Rectangle())
                }
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
                .scaledToFit()
                .frame(width: 50)
                .padding(.horizontal, 5)
        }
    }

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
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
