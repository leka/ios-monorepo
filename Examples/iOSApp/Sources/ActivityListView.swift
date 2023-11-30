// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityListView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    init() {
        print("init ActivityListView")
    }

    var body: some View {
        NavigationStack(path: $navigation.activitiesNavPath) {
            VStack(spacing: 50) {
//                List {
//                    ForEach(Activity.all) { actvity in
//                        NavigationLink(value: actvity) {
//                            Text(actvity.name)
//                        }
//                    }
//                }
//                .listStyle(.automatic)
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityInfoView(activity: activity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mint)
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

#Preview {
    ActivityListView()
}
