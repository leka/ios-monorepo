// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - SampleActivityListView

struct AllTemplateActivitiesView: View {
    // MARK: Internal

    let activities: [Activity] = ContentKit.allTemplateActivities.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: 30) {
                LazyVGrid(columns: self.columns) {
                    ForEach(self.activities) { activity in
                        NavigationLink(destination:
                            ActivityDetailsView(activity: activity, onStartActivity: { activity in
                                self.navigation.currentActivity = activity
                                self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                            })) {
                                ContentGridItem(CurationItemModel(id: activity.uuid, contentType: .activity))
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Template Activities")
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared

    private var columns = Array(repeating: GridItem(), count: 3)
}

#Preview {
    NavigationStack {
        AllTemplateActivitiesView()
    }
}
