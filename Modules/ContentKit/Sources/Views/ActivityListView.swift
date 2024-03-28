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
        LazyVGrid(columns: self.columns) {
            ForEach(self.activities) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                ) {
                    VStack(spacing: 15) {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 120)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!.opacity(0.2), lineWidth: 5)
                            )

                        Text(activity.details.title)
                            .font(.body.bold())

                        Text(activity.details.subtitle ?? "")
                            .font(.caption)
                    }
                    .padding(.vertical)
                }
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
            activities: ContentKit.listSampleActivities(),
            onStartActivity: { _ in
                print("Activity Started")
            }
        )
    }
}
