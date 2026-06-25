// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - AllNewActivities

struct AllNewActivities: View {
    // MARK: Internal

    @State var isActivityPresented: Bool = false

    let activities: [CurationItemModel] = ContentKit.allNewActivities.values.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }.map { CurationItemModel(id: $0.id, name: $0.name, contentType: .activity) }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VerticalActivityGrid(items: self.activities)
            }
        }
        .navigationTitle("New Activities")
    }

    // MARK: Private

    @State private var activityDidEnd: Bool = false

    private var navigation: Navigation = .shared
}

#Preview {
    NavigationStack {
        AllNewActivities()
    }
}
