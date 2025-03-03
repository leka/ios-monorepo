// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - NewExerciseOptions

public struct NewExerciseOptions: Codable {
    // MARK: Lifecycle

    public init(shuffleChoices: Bool = true, validate: Bool = false) {
        self.shuffleChoices = shuffleChoices
        self.validate = validate
    }

    // MARK: Public

    public let shuffleChoices: Bool
    public let validate: Bool

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case shuffleChoices = "shuffle_choices"
        case validate
    }
}
