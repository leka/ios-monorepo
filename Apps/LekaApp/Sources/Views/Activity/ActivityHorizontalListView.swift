// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import DesignKit
import SwiftUI

// MARK: - ActivityHorizontalListView

public struct ActivityHorizontalListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline) {
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
                        VerticalItem(CurationItemModel(id: activity.id, contentType: .activity))
                            .frame(width: 280)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsManager.logEventSelectContent(
                            type: .activity,
                            id: activity.id,
                            name: activity.name,
                            origin: .generalLibrary
                        )
                    })
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack {
                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }
            }
        }
    }
}
