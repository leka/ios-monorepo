// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityListView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    var body: some View {
            VStack(spacing: 50) {
                List {
                    ForEach(Activity.all) { activity in
                        NavigationLink(value: activity) {
                            Text(activity.name)
                        }
                    }
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityInfoView(activity: activity)
            }
            .navigationTitle("List of activities")
    }

}

struct ActivityInfoView: View {

    let activity: Activity

    var body: some View {
        VStack {
            List {
                Section("Info") {
                    Text("Name: \(activity.name)")
                    Text("Id: \(activity.id)")
                }
                Section("Similar Activities") {
                    if let similarActivities = activity.similarActivities {
                        ForEach(Activity.all.filter { similarActivities.contains($0.id) }) { activity in
                            NavigationLink(value: activity) {
                                Text(activity.name)
                            }
                        }

                    } else {
                        Text("No similar activities")
                    }
                }
            }
        }
        .navigationTitle("\(activity.name)")
    }

}

#Preview {
    NavigationStack {
        ActivityListView()
    }
}
