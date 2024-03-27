// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ActivitiesView

struct ActivitiesView: View {
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
                        Text(l10n.ActivitiesView.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(l10n.ActivitiesView.subtitle)
                            .font(.title2)

                        Text(l10n.ActivitiesView.description)
                            .foregroundStyle(.secondary)

                        Divider()
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding()

                ActivityListView(activities: ContentKit.listSampleActivities(), onStartActivity: { activity in
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                        self.navigation.sheetContent = .carereceiverPicker(activity: activity)
                    } else {
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView
                    }
                })
            }
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

// MARK: - l10n.ActivitiesView

// swiftlint:disable line_length

extension l10n {
    enum ActivitiesView {
        static let title = LocalizedString("lekaapp.activities_view.title",
                                           value: "Activities",
                                           comment: "Activities title")

        static let subtitle = LocalizedString("lekaapp.activities_view.subtitle",
                                              value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                              comment: "Activities subtitle")

        static let description = LocalizedString("lekaapp.activities_view.description",
                                                 value: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                                                 comment: "Activities description")
    }
}

// swiftlint:enable line_length

#Preview {
    ActivitiesView()
}
