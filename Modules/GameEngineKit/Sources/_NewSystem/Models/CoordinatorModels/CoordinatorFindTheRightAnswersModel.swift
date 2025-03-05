// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorFindTheRightAnswersModel

public struct CoordinatorFindTheRightAnswersModel {
    public let choices: [CoordinatorFindTheRightAnswersChoiceModel]
}

// MARK: Decodable

extension CoordinatorFindTheRightAnswersModel: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.choices = try container.decode([CoordinatorFindTheRightAnswersChoiceModel].self, forKey: .choices)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(CoordinatorFindTheRightAnswersModel.self, from: data) else {
            log.error("Exercise payload not compatible with FindTheRightAnswers model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
