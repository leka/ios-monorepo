// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - LibraryGamepadsView

struct LibraryGamepadsView: View {
    // MARK: Internal

    var body: some View {
        VStack {
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

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationStack {
        LibraryGamepadsView()
    }
}
