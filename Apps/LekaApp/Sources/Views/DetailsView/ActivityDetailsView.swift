// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ActivityDetailsView

public struct ActivityDetailsView: View {
    // MARK: Lifecycle

    public init(activity: Activity, onStartActivity: ((Activity) -> Void)? = nil) {
        self.activity = activity
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        InfoDetailsView(CurationItemModel(id: self.activity.id, contentType: .story))
            .toolbar {
                if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                    ToolbarItemGroup {
                        if self.libraryManagerViewModel.isActivityFavoritedByCurrentCaregiver(
                            activityID: self.activity.id,
                            caregiverID: currentCaregiverID
                        ) {
                            Image(systemName: "star.circle")
                                .font(.system(size: 21))
                                .foregroundColor(self.styleManager.accentColor ?? .blue)
                        }

                        ContentItemMenu(
                            CurationItemModel(id: self.activity.id, contentType: .activity),
                            caregiverID: currentCaregiverID
                        )
                    }
                }

                ToolbarItem {
                    Button {
                        self.onStartActivity?(self.activity)
                        AnalyticsManager.logEventActivityLaunch(id: self.activity.id, name: self.activity.name, origin: .detailsViewButton)
                    } label: {
                        Image(systemName: "play.fill")
                        Text(l10n.ActivityDetailsView.startActivityButtonLabel)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.lkGreen)
                    .disabled(self.onStartActivity == nil)
                    .opacity(self.onStartActivity == nil ? 0 : 1)
                }
            }
    }

    // MARK: Internal

    var onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManagerViewModel: LibraryManagerViewModel = .shared

    private let activity: Activity
}

// MARK: - l10n.ActivityDetailsView

extension l10n {
    enum ActivityDetailsView {
        static let startActivityButtonLabel = LocalizedString("lekaapp.activity_details_view.start_activity_button_label",
                                                              value: "Start activity",
                                                              comment: "Start activity button label on Activity Details view")
    }
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}
