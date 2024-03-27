// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import SwiftUI

// MARK: - ActivityListView

struct ActivityListView: View {
    // MARK: Lifecycle

    init(activities: [Activity]? = nil) {
        self.activities = activities ?? []
    }

    // MARK: Internal

    let activities: [Activity]

    var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(self.activities) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: { activity in
                        if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                            self.navigation.sheetContent = .carereceiverPicker(activity: activity)
                        } else {
                            self.navigation.currentActivity = activity
                            self.navigation.fullScreenCoverContent = .activityView
                        }
                    })
                ) {
                    VStack(spacing: 15) {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 120)
                            .overlay(
                                Circle()
                                    .stroke(DesignKitAsset.Colors.lekaLightBlue.swiftUIColor, lineWidth: 5)
                            )

                        Text(activity.details.title)
                    }
                    .padding(.vertical)
                }
            }
        }
        .padding()
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationStack {
        ActivityListView(activities: ContentKit.listSampleActivities())
    }
}
