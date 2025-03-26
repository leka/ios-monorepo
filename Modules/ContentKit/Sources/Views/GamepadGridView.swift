// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import SwiftUI

// MARK: - GamepadGridView

public struct GamepadGridView: View {
    // MARK: Lifecycle

    public init(gamepads: [Activity]? = nil, onStartGamepad: ((Activity) -> Void)?) {
        self.gamepads = gamepads ?? []
        self.onStartGamepad = onStartGamepad
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns, spacing: 50) {
            ForEach(self.gamepads) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: self.onStartGamepad)
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
                            .frame(width: 160)
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

                        Spacer()
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    log.debug("Gamepad selected: \(activity.name)")
                    AnalyticsManager.logEventSelectContent(
                        type: .gamepad,
                        id: activity.id,
                        name: activity.name,
                        origin: .generalLibrary
                    )
                })
            }
        }
    }

    // MARK: Internal

    let gamepads: [Activity]
    let onStartGamepad: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    private let columns = Array(repeating: GridItem(), count: 2)
}

#Preview {
    NavigationStack {
        GamepadGridView(
            gamepads: Array(ContentKit.allActivities[0..<3]),
            onStartGamepad: { _ in
                print("Activity Started")
            }
        )
    }
}
