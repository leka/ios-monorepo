// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - NewActivityPayload

public struct NewActivityPayload {
    public var exerciseGroups: [NewExerciseGroup]
}

// MARK: - NewExerciseGroup

public struct NewExerciseGroup: Decodable {
    // MARK: Lifecycle

    public init(exercises: [NewExercise]) {
        self.exercises = exercises
    }

    // MARK: Public

    public let exercises: [NewExercise]

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case exercises = "group"
    }
}
