// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorFindTheRightOrderModel

public struct CoordinatorFindTheRightOrderModel {
    public let choices: [CoordinatorFindTheRightOrderChoiceModel]
}

// MARK: Decodable

extension CoordinatorFindTheRightOrderModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.choices = try container.decode([CoordinatorFindTheRightOrderChoiceModel].self, forKey: .choices)
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
