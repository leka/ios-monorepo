// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorFindTheRightOrderChoiceModel

public struct CoordinatorFindTheRightOrderChoiceModel: Identifiable, Equatable {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, type: ChoiceType = .text, alreadyOrdered: Bool = false) {
        self.id = id
        self.value = value
        self.type = type
        self.alreadyOrdered = alreadyOrdered
    }

    // MARK: Public

    public let id: UUID

    // MARK: Internal

    static let zero = CoordinatorFindTheRightOrderChoiceModel(value: "")

    let value: String
    let type: ChoiceType
    let alreadyOrdered: Bool
}

// MARK: Decodable

extension CoordinatorFindTheRightOrderChoiceModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.type = try container.decode(ChoiceType.self, forKey: .type)
        self.alreadyOrdered = try container.decodeIfPresent(Bool.self, forKey: .alreadyOrdered) ?? false

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case type
        case alreadyOrdered = "already_ordered"
    }
}
