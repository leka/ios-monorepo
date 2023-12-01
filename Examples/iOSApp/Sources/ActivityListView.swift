// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityListView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    @State var value: Int = 0

//        @State var path: NavigationPath = NavigationPath() {
//            didSet {
//                print("didSet path: \(path)")
//            }
//        }


    init() {
        print("ActivityListView init")
    }

    var body: some View {
        NavigationStack(path: $navigation.activitiesNavPath) {
            //        NavigationStack(path: $path) {
            //        NavigationStack {
            //            ZStack {
            //                Rectangle().fill(Color.green).edgesIgnoringSafeArea(.all)
            //                VStack {
            //                    Text("Value: \(value)")
            //                        .foregroundColor(.white)
            //                        .font(.title)
            //                        .onTapGesture {
            //                            value += 1
            //                        }
            //                        .onAppear {
            //                            print("View 2 Text appeared")
            //                        }
            //
            //                    NavigationLink(value: Destination.activity(id: Activity.all[0].id)) {
            //                        Text(Activity.all[0].name)
            //                    }
            //
            //                    NavigationLink("with destination") {
            //                        Text("with destination")
            //                    }
            //
            //                    Button("Go to Activity 3") {
            //                        path.append( Activity.all[2].id)
            //                    }
            //
            //                    Button("Go to Activity 1, 2, 3") {
            //                        path.append(contentsOf: [
            //                            Activity.all[0],
            //                            Activity.all[1],
            //                            Activity.all[2],
            //                        ])
            //                    }
            //                }
            //            }
            //            .navigationDestination(for: Destination.self) { activity in
            //                ActivityInfoView(activity: activity)
            //            }
            //
            //            .onTapGesture {
            //                print("View2 tapped")
            //            }
            //            .onAppear {
            //                print("View2 appeared")
            //            }
            //        }
            //        .onAppear {
            //            print("onAppear ActivityListView")
            //        }
            //        .onDisappear {
            //            print("onDisappear ActivityListView")
            //        }
            //        NavigationStack(path: $path) {
            VStack(spacing: 50) {
                List {
                    ForEach(Activity.all) { actvity in
                        NavigationLink(value: actvity) {
                            Text(actvity.name)
                        }
                        .isDetailLink(false)
                    }
                }
                .listStyle(.automatic)
            }
            .navigationDestination(for: Activity.self) { activity in
//                if case let .activity(id) = destination {
//                    let activity = Activity.all.first { $0.id == id }
                    ActivityInfoView(activity: activity)
                    //                    CurriculumInfoView(curriculum: curriculum!)
//                } else { Text("Unknown activity") }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mint)

        }
        .navigationViewStyle(.stack)
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
