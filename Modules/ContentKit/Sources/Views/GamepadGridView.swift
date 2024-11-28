// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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
                        .onAppear {
                            AnalyticsManager.logEventSelectContent(
                                type: .gamepad,
                                id: activity.id,
                                name: activity.name,
                                origin: .generalLibrary
                            )
                        }
                ) {
                    VStack {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .padding(.bottom, 15)

                        Text(activity.details.title)
                            .font(.headline)
                            .foregroundStyle(Color.primary)

                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: Internal

    let gamepads: [Activity]
    let onStartGamepad: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

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
