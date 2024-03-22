// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import MarkdownUI
import SwiftUI

// MARK: - ActivityListView

struct ActivityListView: View {
    let activities: [Activity] = ContentKit.listSampleActivities() ?? []

    var body: some View {
        List {
            ForEach(self.activities) { activity in
                NavigationLink(destination: ActivityDetailsView(activity: activity)) {
                    Image(uiImage: activity.details.iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    Text("\(activity.details.title)")
                }
                NavigationLink(destination: ActivityDebugView(activity: activity)) {
                    Image(uiImage: activity.details.iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .padding(.leading, 11)
                    Text("\(activity.details.title) (DEBUG)")
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Activities")
    }
}

#Preview {
    NavigationStack {
        ActivityListView()
    }
}
