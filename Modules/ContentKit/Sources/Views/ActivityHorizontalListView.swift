// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ActivityHorizontalListView

public struct ActivityHorizontalListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline) {
                ForEach(self.activities) { activity in
                    NavigationLink(destination:
                        ActivityDetailsView(activity: activity, onStartActivity: self.onActivitySelected)
                    ) {
                        VStack(spacing: 10) {
                            Image(uiImage: activity.details.iconImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 150)
                                .overlay(
                                    Circle()
                                        .stroke(self.styleManager.accentColor!, lineWidth: 1)
                                )

                            Text(activity.details.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.primary)
                                .fixedSize(horizontal: false, vertical: true)

                            Text(activity.details.subtitle ?? "")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.secondary)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer()
                        }
                        .frame(width: 280)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let activities: [Activity]
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    private let rows = [GridItem()]
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack {
                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    ActivityHorizontalListView(
                        activities: ContentKit.allActivities,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }
            }
        }
    }
}
