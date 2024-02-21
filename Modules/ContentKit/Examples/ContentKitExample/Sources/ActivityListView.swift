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
                    AsyncImage(url: activity.details.iconURL) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "photo.circle")
                    }
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())

                    Text(activity.name)
                }
            }
        }
        .navigationTitle("Activities")
        .onAppear {
            let skills = Skills.list
            for (index, skill) in skills.enumerated() {
                print("skill \(index + 1)")
                print("id: \(skill.id)")
                print("name: \(skill.name)")
                print("description: \(skill.description)")
            }

            let hmis = HMI.list
            for (index, hmi) in hmis.enumerated() {
                print("hmi \(index + 1)")
                print("id: \(hmi.id)")
                print("name: \(hmi.name)")
                print("description: \(hmi.description)")
            }

            let authors = Authors.list
            for (index, author) in authors.enumerated() {
                print("author \(index + 1)")
                print("id: \(author.id)")
                print("name: \(author.name)")
                print("description: \(author.description)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ActivityListView()
    }
}
