// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CategoryRemotesView

struct CategoryRemotesView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "dice")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(self.category.details.subtitle)
                            .font(.title2)

                        Text(self.category.details.description)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)

                ActivityGridView(activities: self.category.activities, onStartActivity: { activity in
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                        self.navigation.sheetContent = .carereceiverPicker(activity: activity)
                    } else {
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView
                    }
                })
            }
        }
        .navigationTitle(self.category.details.title)
    }

    // MARK: Private

    private let category: CategoryRemotes = .shared

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        CategoryRemotesView()
    }
}
