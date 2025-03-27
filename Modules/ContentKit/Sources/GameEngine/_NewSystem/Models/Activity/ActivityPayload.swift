// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - ActivityPayload

import ContentKit

// MARK: - ActivityPayload

public struct ActivityPayload: Decodable {
    // MARK: Public

    public let exerciseGroups: [ExerciseGroup]
    public let options: ActivityOptions

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case options
        case exerciseGroups = "exercise_groups"
    }
}

// MARK: - ActivityOptions

public struct ActivityOptions: Decodable {
    // MARK: Public

    public let shuffleExercises: Bool
    public let shuffleGroups: Bool

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case shuffleExercises = "shuffle_exercises"
        case shuffleGroups = "shuffle_groups"
    }
}

// MARK: - ExerciseGroup

public struct ExerciseGroup: Decodable {
    public let group: [NewExercise]
}
