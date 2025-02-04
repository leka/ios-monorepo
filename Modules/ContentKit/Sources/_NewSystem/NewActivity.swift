// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit

// MARK: - NewActivity

public struct NewActivity: Decodable, Identifiable {
    // MARK: Lifecycle

    public init(id: String, name: String, payload: Data) {
        self.id = id
        self.name = name
        self.payload = payload
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let payload = try container.decode(AnyCodable.self, forKey: .payload)

        self.payload = try JSONEncoder().encode(payload)
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let payload: Data

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case payload = "exercises_payload"
    }
}

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
