// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public struct Activity: Codable, Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let image: String
    public let shuffleSequences: Bool
    public var sequence: [ExerciseSequence]

    private enum CodingKeys: String, CodingKey {
        case id, name, description, image, sequence
        case shuffleSequences = "shuffle_sequences"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.sequence = try container.decode([ExerciseSequence].self, forKey: .sequence)

        self.shuffleSequences = try container.decodeIfPresent(Bool.self, forKey: .shuffleSequences) ?? false
    }
}
