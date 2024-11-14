// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
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
                        .onAppear {
                            AnalyticsManager.shared.logEventSelectContent(
                                type: .educationalGame,
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
