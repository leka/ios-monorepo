// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ActivityGridView

public struct ActivityGridView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
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
                        ContentGridItem(CurationItemModel(id: activity.id, contentType: .activity))
                    }
                    .logEventScreenView(
                        screenName: "activity_details",
                        context: .splitView,
                        parameters: [
                            "lk_activity_id": "\(activity.name)-\(activity.id)",
                        ]
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?
}

#Preview {
    NavigationStack {
        ActivityGridView(
            activities: Array(ContentKit.allActivities.values),
            onStartActivity: { _ in
                print("Activity Started")
            }
        )
    }
}
