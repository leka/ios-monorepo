// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - LibraryActivityListView

public struct LibraryActivityListView: View {
    // MARK: Lifecycle

    public init(activities: [Activity]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.activities = activities ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        Table(self.activities) {
            TableColumn(String(l10n.Library.titleColumnLabel.characters)) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                        .logEventScreenView(
                            screenName: "activity_details",
                            context: .splitView,
                            parameters: ["lk_activity_id": "\(activity.name)-\(activity.id)"]
                        )
                ) {
                    HStack(spacing: 10) {
                        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id, self.libraryManagerViewModel
                            .isActivityFavoritedByCurrentCaregiver(
                                activityID: activity.id,
                                caregiverID: currentCaregiverID
                            )
                        {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(self.styleManager.accentColor ?? .blue)
                                .frame(width: 10)
                        } else {
                            Color.clear
                                .frame(width: 10)
                        }

                        Image(uiImage: activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(activity.details.title)
                                .font(.headline)

                            if let subtitle = activity.details.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                            }
                        }

                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.logEventSelectContent(
                        type: .activity,
                        id: activity.id,
                        name: activity.name,
                        origin: .personalLibrary
                    )
                })
            }
            .width(min: 400, ideal: 450, max: .infinity)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getGestureIconUIImage(for: activity))
            }
            .width(40)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .ears))
            }
            .width(40)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .robot))
            }
            .width(40)

            TableColumn("") { activity in
                IconImageView(image: ContentKit.getTemplateIconUIImage(for: activity))
            }
            .width(40)

            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                TableColumn("") { activity in
                    ContentItemMenu(
                        CurationItemModel(id: activity.uuid, contentType: .activity),
                        caregiverID: currentCaregiverID
                    )
                }
                .width(40)
            }

            TableColumn("") { activity in
                Button {
                    self.onStartActivity?(activity)
                    AnalyticsManager.logEventActivityLaunch(id: activity.id, name: activity.name, origin: .listButton)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text(l10n.LibraryActivityListView.playButtonLabel)
                            .font(.callout)
                    }
                    .foregroundColor(.lkGreen)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .overlay(
                        Capsule()
                            .stroke(Color.lkGreen, lineWidth: 1)
                    )
                }
            }
            .width(80)
        }
        .tableStyle(.inset)
    }

    // MARK: Internal

    let activities: [Activity]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    private struct IconImageView: View {
        let image: UIImage?

        var body: some View {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.secondary)
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(.horizontal, 5)
            } else {
                Color.clear
                    .frame(width: 40, height: 40)
            }
        }
    }

    @ObservedObject private var styleManager: StyleManager = .shared

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
}

// MARK: - l10n.LibraryActivityListView

extension l10n {
    enum LibraryActivityListView {
        static let playButtonLabel = LocalizedString("lekaapp.library_activity_list_view.play_button_label",
                                                     value: "Play",
                                                     comment: "Play button label on Library Activity List view")
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            LibraryActivityListView(
                activities: Array(ContentKit.allActivities.values),
                onStartActivity: { _ in
                    print("Activity Started")
                }
            )
        }
    }
}
