// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
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
                    HStack(spacing: 30) {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 100)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!.opacity(0.2), lineWidth: 5)
                            )

                        VStack(alignment: .leading) {
                            Text(activity.details.title)
                                .font(.body.bold())
                                .frame(alignment: .leading)

                            Text(activity.details.subtitle ?? "")
                                .font(.caption)
                                .frame(alignment: .leading)
                        }
                        .padding(.vertical)
                    }
                }
                .frame(maxHeight: 120)
            }
        }
        .padding()
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    NavigationStack {
        ActivityListView(
            activities: ContentKit.allActivities,
            onStartActivity: { _ in
                print("Activity Started")
            }
        )
    }
}
