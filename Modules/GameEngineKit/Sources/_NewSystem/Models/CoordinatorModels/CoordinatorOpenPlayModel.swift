// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorOpenPlayModel

public struct CoordinatorOpenPlayModel {
    public let choices: [CoordinatorOpenPlayChoiceModel]
}

// MARK: Decodable

extension CoordinatorOpenPlayModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.choices = try container.decode([CoordinatorOpenPlayChoiceModel].self, forKey: .choices)
    }

    public init?(data: Data) {
        if let model = try? JSONDecoder().decode(CoordinatorOpenPlayModel.self, from: data) {
            self = model
        } else {
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
