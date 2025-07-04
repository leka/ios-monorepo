// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorCountTheRightNumberModel

public struct CoordinatorCountTheRightNumberModel {
    public let groups: [CoordinatorCountTheRightNumberChoiceModel]
}

// MARK: Decodable

extension CoordinatorCountTheRightNumberModel: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groups = try container.decode([CoordinatorCountTheRightNumberChoiceModel].self, forKey: .groups)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(CoordinatorCountTheRightNumberModel.self, from: data) else {
            logGEK.error("Exercise payload not compatible with CountTheRightNumber model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    enum CodingKeys: String, CodingKey {
        case groups = "choices"
    }
}
