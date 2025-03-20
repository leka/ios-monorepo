// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import SwiftUI

// MARK: - ActivityHorizontalListView

public struct ActivityHorizontalListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline) {
                ForEach(self.activities) { activity in
                    NavigationLink(destination:
                        ActivityDetailsView(activity: activity, onStartActivity: self.onActivitySelected)
                            .logEventScreenView(
                                screenName: "activity_details",
                                context: .splitView,
                                parameters: [
                                    "lk_activity_id": "\(activity.name)-\(activity.id)",
                                ]
                            )
                    ) {
                        VStack(spacing: 10) {
                            Image(uiImage: activity.details.iconImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 150)
                                .overlay(
                                    Circle()
                                        .stroke(self.styleManager.accentColor!, lineWidth: 1)
                                )

                            HStack(spacing: 5) {
                                Text(activity.details.title)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.primary)
                                    .fixedSize(horizontal: false, vertical: true)

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
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.secondary)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer()
                        }
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
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private let columns = Array(repeating: GridItem(), count: 3)
    private let rows = [GridItem()]
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack {
                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }
            }
        }
    }
}
