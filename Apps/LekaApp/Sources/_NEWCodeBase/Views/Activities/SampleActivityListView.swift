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

    let activities: [Activity] = ContentKit.listSampleActivities() ?? []

    var body: some View {
        List {
            ForEach(self.activities) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity)
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    self.selectedActivity = activity
                                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                                        self.navigation.sheetContent = .carereceiverPicker(activity: activity)
                                    } else {
                                        self.navigation.currentActivity = activity
                                        self.navigation.fullScreenCoverContent = .activityView
                                    }
                                } label: {
                                    Image(systemName: "play.circle")
                                    Text("Start activity")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.lkGreen)
                            }
                        }
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
    @State private var selectedActivity: Activity?
}

// MARK: - l10n.SampleActivityListView

// swiftlint:disable line_length

extension l10n {
    enum SampleActivityListView {
        static let buttonLabel = LocalizedString("lekaapp.sample_activity_list_view.button_label", value: "Start activity", comment: "Start activity button label on Sample Activity List view")
    }
}

// swiftlint:enable line_length

#Preview {
    NavigationStack {
        SampleActivityListView()
    }
}
