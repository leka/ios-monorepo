// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Activity: Identifiable, Hashable {
    let id: String
    let name: String
    let similarActivities: [String]?

    static let all: [Activity] = [
        Activity(id: "activity_1", name: "Activity 1", similarActivities: ["activity_2", "activity_3"]),
        Activity(id: "activity_2", name: "Activity 2", similarActivities: ["activity_1", "activity_3"]),
        Activity(id: "activity_3", name: "Activity 3", similarActivities: ["activity_1", "activity_2"]),
        Activity(id: "activity_4", name: "Activity 4", similarActivities: nil),
        Activity(id: "activity_5", name: "Activity 5", similarActivities: nil),
        Activity(id: "activity_6", name: "Activity 6", similarActivities: nil),
        Activity(id: "activity_7", name: "Activity 7", similarActivities: nil),
        Activity(id: "activity_8", name: "Activity 8", similarActivities: nil),
        Activity(id: "activity_9", name: "Activity 9", similarActivities: nil),
        Activity(id: "activity_10", name: "Activity 10", similarActivities: nil),
    ]
}

struct Curriculum: Identifiable, Hashable {
    let id: String
    let name: String
    let activities: [Activity]
    let similarCurriculums: [String]?

    init(id: String, name: String, activities: [String], similarCurriculums: [String]?) {
        self.id = id
        self.name = name
        self.activities = activities.compactMap { activityId in
            Activity.all.first { $0.id == activityId }
        }
        self.similarCurriculums = similarCurriculums
    }

    static let all: [Curriculum] = [
        Curriculum(
            id: "curriculum_1", name: "Curriculum 1", activities: ["activity_1", "activity_2", "activity_3"],
            similarCurriculums: ["curriculum_2", "curriculum_3"]),
        Curriculum(
            id: "curriculum_2", name: "Curriculum 2", activities: ["activity_4", "activity_5", "activity_6"],
            similarCurriculums: ["curriculum_1", "curriculum_3"]),
        Curriculum(
            id: "curriculum_3", name: "Curriculum 3", activities: ["activity_7", "activity_8", "activity_9"],
            similarCurriculums: ["curriculum_1", "curriculum_2"]),
        Curriculum(id: "curriculum_4", name: "Curriculum 4", activities: ["activity_10"], similarCurriculums: nil),
    ]
}
