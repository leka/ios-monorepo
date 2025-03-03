// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorAssociateCategoriesChoiceModel

// swiftlint:disable:next type_name
public struct CoordinatorAssociateCategoriesChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, category: AssociateCategory?, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.category = category
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let category: AssociateCategory?
    let type: ChoiceType
}

// MARK: Decodable

extension CoordinatorAssociateCategoriesChoiceModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.category = try container.decodeIfPresent(AssociateCategory.self, forKey: .category)
        self.type = try container.decode(ChoiceType.self, forKey: .type)

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case category
        case type
    }
}
