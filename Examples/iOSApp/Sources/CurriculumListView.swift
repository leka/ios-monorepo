// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CurriculumListView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    init() {
        print("init CurriculumListView")
    }

    var body: some View {
        NavigationStack(path: $navigation.curriculumsNavPath) {
            VStack(spacing: 50) {
                //                List {
                //                    ForEach(Curriculum.all) { curriculum in
                //                        NavigationLink(value: curriculum) {
                //                            Text(curriculum.name)
                //                        }
                //                    }
                //                }
                //                .listStyle(.automatic)
            }
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
        VStack {
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
        }
        .navigationTitle("\(curriculum.name)")
    }
}

#Preview {
    CurriculumListView()
}
