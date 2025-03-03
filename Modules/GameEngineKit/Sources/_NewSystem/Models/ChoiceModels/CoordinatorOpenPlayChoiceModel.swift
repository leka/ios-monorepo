// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorOpenPlayChoiceModel

public struct CoordinatorOpenPlayChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let type: ChoiceType
}

// MARK: Decodable

extension CoordinatorOpenPlayChoiceModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.type = try container.decode(ChoiceType.self, forKey: .type)

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case type
    }
}
