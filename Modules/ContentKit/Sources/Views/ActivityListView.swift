// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ActivityListView

public struct ActivityListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(self.activities) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                ) {
                    HStack(alignment: .center, spacing: 30) {
                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            HStack {
                                Text(activity.details.title)
                                    .font(.headline)
                                    .frame(alignment: .leading)
                            }

                            if let subtitle = activity.details.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                                    .frame(alignment: .leading)
                            }
                        }
                        .padding(.vertical)

                        Spacer()

                        if let templateIconUIImage = ContentKit.getTemplateIconUIImage(for: activity) {
                            Image(uiImage: templateIconUIImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .padding(.horizontal)
                        }

                        Button {
                            self.onStartActivity?(activity)
                        } label: {
                            Image(systemName: "play.circle")
                                .font(.system(size: 24))
                                .contentShape(Rectangle())
                        }
                        .tint(.lkGreen)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
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

// MARK: - l10n.ActivityListView

extension l10n {
    enum ActivityListView {
        static let startActivityButtonLabel = LocalizedString("content_kit.activity_list_view.start_activity_button_label",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Start",
                                                              comment: "Start activity button label on ActivityListView")
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            ScrollView {
                ActivityListView(
                    activities: ContentKit.allActivities,
                    onStartActivity: { _ in
                        print("Activity Started")
                    }
                )
            }
        }
    }
}
