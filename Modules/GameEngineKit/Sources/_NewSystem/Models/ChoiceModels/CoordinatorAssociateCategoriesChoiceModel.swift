// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorAssociateCategoriesChoiceModel

// swiftlint:disable:next type_name
public struct CoordinatorAssociateCategoriesChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, category: AssociateCategory?, type: ChoiceType = .text, isDropzone: Bool = false) {
        self.id = id
        self.value = value
        self.category = category
        self.isDropzone = isDropzone
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let category: AssociateCategory?
    let isDropzone: Bool
    let type: ChoiceType
}

// MARK: Decodable

extension CoordinatorAssociateCategoriesChoiceModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.category = try container.decodeIfPresent(AssociateCategory.self, forKey: .category)
        self.isDropzone = try container.decodeIfPresent(Bool.self, forKey: .isDropzone) ?? false
        self.type = try container.decodeIfPresent(ChoiceType.self, forKey: .type) ?? .text

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case category
        case type
        case isDropzone = "is_dropzone"
    }
}
