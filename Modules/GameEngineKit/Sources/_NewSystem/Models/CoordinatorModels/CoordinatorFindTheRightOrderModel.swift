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

    public init?(data: Data) {
        if let model = try? JSONDecoder().decode(CoordinatorFindTheRightOrderModel.self, from: data) {
            self = model
        } else {
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
