// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CurriculumListView: View {

    @EnvironmentObject var navigation: Navigation

    var body: some View {
        // ? Fix animation w/ multiple navigation stacks, see https://developer.apple.com/forums/thread/728132
        NavigationStack(path: $navigation.curriculumsNavPath.animation(.linear(duration: 0))) {
            VStack(spacing: 50) {
                List {
                    ForEach(Curriculum.all) { curriculum in
                        NavigationLink(value: curriculum) {
                            Text(curriculum.name)
                        }
                    }
                }
                .listStyle(.automatic)
            }
            .navigationTitle("List of Curriculums")
            .navigationDestination(for: Curriculum.self) { curriculum in
                CurriculumInfoView(curriculum: curriculum)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.teal)
        }
    }
}

struct CurriculumInfoView: View {

    let curriculum: Curriculum

    var body: some View {
        VStack(spacing: 50) {
            List {
                Section("Info") {
                    Text("Name: \(curriculum.name)")
                    Text("Id: \(curriculum.id)")
                }

                Section("List of activities") {
                    ForEach(Activity.all.filter { curriculum.activities.contains($0.id) }) { activity in
                        NavigationLink(destination: ActivityInfoView(activity: activity)) {
                            Text(activity.name)
                        }
                    }
                }

                Section("Similar Curriculums") {
                    if let similarCurriculum = curriculum.similarCurriculums {
                        ForEach(Curriculum.all.filter { similarCurriculum.contains($0.id) }) { curriculum in
                            NavigationLink(destination: CurriculumInfoView(curriculum: curriculum)) {
                                Text(curriculum.name)
                            }
                        }

                    } else {
                        Text("No similar curriculums")
                    }
                }
            }

            Button("Back to root", systemImage: "arrow.backward.circle") {
                Navigation.shared.backToRoot()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .navigationTitle("\(curriculum.name)")
    }

}
