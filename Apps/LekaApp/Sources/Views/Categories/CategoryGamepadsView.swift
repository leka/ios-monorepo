// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CategoryRemotesView

struct CategoryGamepadsView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 30) {
                Image(systemName: "gamecontroller")
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.bottom)

            Spacer()

            GamepadGridView(gamepads: self.category.activities, onStartGamepad: { activity in
                if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                    self.navigation.sheetContent = .carereceiverPicker(activity: activity, story: nil)
                } else {
                    self.navigation.currentActivity = activity
                    self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                }
            })

            Spacer()
        }
        .navigationTitle(self.category.details.title)
    }

    // MARK: Private

    private let category: CategoryGamepads = .shared

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        CategoryGamepadsView()
    }
}
