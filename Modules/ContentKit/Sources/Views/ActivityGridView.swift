// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
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
        LazyVGrid(columns: self.columns) {
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
                    VStack {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 120)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!.opacity(0.2), lineWidth: 5)
                            )
                            .padding(.bottom, 15)

                        HStack(spacing: 5) {
                            Text(activity.details.title)
                                .font(.headline)
                                .foregroundStyle(Color.primary)

                            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
                               self.libraryManagerViewModel.isActivityFavoritedByCurrentCaregiver(
                                   activityID: activity.id,
                                   caregiverID: currentCaregiverID
                               )
                            {
                                Text(Image(systemName: "star.fill"))
                                    .font(.caption)
                                    .foregroundColor(self.styleManager.accentColor ?? .blue)
                            }
                        }

                        Text(activity.details.subtitle ?? "")
                            .font(.body)
                            .foregroundStyle(Color.secondary)

                        Spacer()
                    }
                    .padding(.vertical)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.logEventSelectContent(
                        type: .educationalGame,
                        id: activity.id,
                        name: activity.name,
                        origin: .generalLibrary
                    )
                })
            }
        }
        .padding()
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private let columns = Array(repeating: GridItem(), count: 3)
}

#Preview {
    NavigationStack {
        ActivityGridView(
            activities: ContentKit.allActivities,
            onStartActivity: { _ in
                print("Activity Started")
            }
        )
    }
}
