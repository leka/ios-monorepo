// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorAssociateCategoriesModel

public struct CoordinatorAssociateCategoriesModel {
    public let choices: [CoordinatorAssociateCategoriesChoiceModel]
}

// MARK: Decodable

extension CoordinatorAssociateCategoriesModel: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.choices = try container.decode([CoordinatorAssociateCategoriesChoiceModel].self, forKey: .choices)
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
