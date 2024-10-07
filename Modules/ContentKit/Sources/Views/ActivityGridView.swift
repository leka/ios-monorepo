// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
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
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    let CGID: String = self.caregiverManagerViewModel.currentCaregiver?.id ?? ""
                                    let savedActivity = SavedActivity(
                                        id: activity.uuid,
                                        caregiverID: CGID
                                    )
                                    if self.rootAccountViewModel.isActivitySaved(activityID: activity.uuid) {
                                        self.rootAccountViewModel.removeSavedActivity(activityID: activity.uuid)
                                    } else {
                                        self.rootAccountViewModel.addSavedActivity(savedActivity)
                                    }
                                } label: {
                                    if self.rootAccountViewModel.isActivitySaved(activityID: activity.uuid) {
                                        Image(systemName: "trash")
                                        Text("Remove Activity")
                                    } else {
                                        Image(systemName: "square.and.arrow.down")
                                        Text("Save Activity")
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(self.rootAccountViewModel.isActivitySaved(activityID: activity.uuid) ? .red : .purple)
                            }
                        }
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

                        Text(activity.details.title)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        Text(activity.details.subtitle ?? "")
                            .font(.body)
                            .foregroundStyle(Color.secondary)

                        Spacer()
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
    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
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
