// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - AllDraftActivitiesView

struct AllDraftActivitiesView: View {
    let activities: [CurationItemModel] = ContentKit.allDraftActivities.values.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }.map { CurationItemModel(id: $0.id, name: $0.name, contentType: .activity) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VerticalActivityGrid(items: self.activities)
        }
        .navigationTitle("Draft Activities")
    }
}

#Preview {
    NavigationStack {
        AllDraftActivitiesView()
    }
}
