// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    var body: some View {
        VStack {
            Text("Try programmatic navigation")
                .font(.headline)

            Button("Go to Activities / Activity 1") {
                navigation.set(path: Activity.all[0], for: .activities)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)

            Button("Go to Activities / Activity 1 / Activity 2 / Activity 3") {
                navigation.set(path: Activity.all[0], Activity.all[1], Activity.all[2], for: .activities)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)

            Button("Go to Curriculums / Curriculum 1") {
                navigation.set(path: Curriculum.all[0], for: .curriculums)
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)

            Button("Go to Curriculums / Curriculum 1 / Activity 2 (w/ objects)") {
                navigation.set(path: Curriculum.all[0], Curriculum.all[0].activities[1], for: .curriculums)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)

            Button("Go to Curriculums / Curriculum 1 / Activity 2 (w/ id + index)") {
                navigation.set(curriculum: "curriculum_1", activity: 1)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)

            Button("Go to Curriculums / Curriculum 1 / Activity -1 (w/ id + index) NOT WORKING") {
                navigation.set(curriculum: "curriculum_1", activity: -1)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button("Go to Curriculums / Curriculum 1 / Activity 1 (w/ id + id)") {
                navigation.set(curriculum: "curriculum_1", activity: "activity_1")
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)

            Button("Go to Curriculums / Curriculum 1 / Activity 1 (w/ id + id) NOT WORKING") {
                navigation.set(curriculum: "curriculum_1", activity: "bad_id")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cyan)
        .navigationTitle("What's new?")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
