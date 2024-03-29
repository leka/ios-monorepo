// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import GameEngineKit
import LocalizationKit
import SwiftUI

// MARK: - SampleActivityListView

struct SampleActivityListView: View {
    // MARK: Internal

    let activities: [Activity] = ContentKit.activityList

    var body: some View {
        List {
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
                    Image(uiImage: activity.details.iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())

                    Text(activity.details.title)
                }
            }
        }
        .navigationTitle("Sample Activities")
    }

    // MARK: Private

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationStack {
        SampleActivityListView()
    }
}
