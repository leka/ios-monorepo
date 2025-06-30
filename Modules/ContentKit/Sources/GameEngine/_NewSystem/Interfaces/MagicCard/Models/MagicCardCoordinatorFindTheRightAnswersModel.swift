// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - MagicCardCoordinatorFindTheRightAnswersModel

public struct MagicCardCoordinatorFindTheRightAnswersModel {
    public let choices: [MagicCardCoordinatorFindTheRightAnswersChoiceModel]
}

// MARK: Decodable

extension MagicCardCoordinatorFindTheRightAnswersModel: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.choices = try container.decode([MagicCardCoordinatorFindTheRightAnswersChoiceModel].self, forKey: .choices)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(MagicCardCoordinatorFindTheRightAnswersModel.self, from: data) else {
            logGEK.error("Exercise payload not compatible with MagicCard FindTheRightAnswers model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    enum CodingKeys: String, CodingKey {
        case choices
    }
}
