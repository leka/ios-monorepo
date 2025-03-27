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

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(CoordinatorFindTheRightOrderModel.self, from: data) else {
            logGEK.error("Exercise payload not compatible with FindTheRightOrder model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
