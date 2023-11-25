// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityListView: View {

    @EnvironmentObject var navigation: Navigation

    var body: some View {
        // ? Fix animation w/ multiple navigation stacks, see https://developer.apple.com/forums/thread/728132
        NavigationStack(path: $navigation.activitiesNavPath.animation(.linear(duration: 0))) {
            VStack(spacing: 50) {
                List {
                    ForEach(Activity.all) { actvity in
                        NavigationLink(value: actvity) {
                            Text(actvity.name)
                        }
                    }
                }
                .listStyle(.automatic)
            }
            .navigationTitle("List of Activities")
            .navigationDestination(for: Activity.self) { activity in
                ActivityInfoView(activity: activity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.teal)
        }
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
                            NavigationLink(destination: ActivityInfoView(activity: activity)) {
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
