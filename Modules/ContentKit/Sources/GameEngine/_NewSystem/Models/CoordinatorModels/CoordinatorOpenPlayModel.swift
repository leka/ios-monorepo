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

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(CoordinatorOpenPlayModel.self, from: data) else {
            logGEK.error("Exercise payload not compatible with OpenPlay model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
