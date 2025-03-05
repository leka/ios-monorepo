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

    public init?(data: Data) {
        if let model = try? JSONDecoder().decode(CoordinatorAssociateCategoriesModel.self, from: data) {
            self = model
        } else {
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
