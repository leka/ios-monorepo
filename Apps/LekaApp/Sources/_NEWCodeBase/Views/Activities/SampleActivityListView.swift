// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct SampleActivityListView: View {
    let activities: [Activity] = ContentKit.listSampleActivities() ?? []

    var body: some View {
        List {
            ForEach(self.activities) { activity in
                NavigationLink(destination: ActivityDetailsView(activity: activity)) {
                    AsyncImage(url: activity.details.iconURL) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "photo.circle")
                    }
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())

                    Text(activity.details.title)
                }
            }
        }
        .navigationTitle("Sample Activities")
    }
}

#Preview {
    NavigationStack {
        SampleActivityListView()
    }
}
