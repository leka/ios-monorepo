// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
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
                            ActivityDetailedListItem(activity)
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

                        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                            ContentItemMenu(
                                CurationItemModel(id: activity.id, name: activity.name, contentType: .activity),
                                caregiverID: currentCaregiverID
                            )
                            .frame(width: 40)
                        }

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

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

// MARK: - l10n.ActivityListView

extension l10n {
    enum ActivityListView {
        static let playButtonLabel = LocalizedString("lekaapp.activity_list_view.play_button_label",
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
                    activities: Array(ContentKit.allActivities.values),
                    onStartActivity: { _ in
                        print("Activity Started")
                    }
                )
            }
        }
    }
}
