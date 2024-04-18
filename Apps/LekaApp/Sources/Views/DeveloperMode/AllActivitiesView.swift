// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import GameEngineKit
import LocalizationKit
import SwiftUI

// MARK: - SampleActivityListView

struct AllActivitiesView: View {
    // MARK: Internal

    let activities: [Activity] = ContentKit.allActivities.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    var body: some View {
        ScrollView(showsIndicators: true) {
            ActivityGridView(activities: self.activities, onStartActivity: { activity in
                self.navigation.currentActivity = activity
                self.navigation.fullScreenCoverContent = .activityView(carereceiver: nil)
            })
        }
        .navigationTitle("All Activities")
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationStack {
        AllActivitiesView()
    }
}
