// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorCountTheRightNumberChoiceModel

// swiftlint:disable:next type_name
public struct CoordinatorCountTheRightNumberChoiceModel {
    // MARK: Lifecycle

    public init(value: String, type: ChoiceType = .text, number: Int, expected: Int) {
        self.value = value
        self.type = type
        self.expected = expected
        self.choiceIDs = (0..<number).map { _ in UUID() }
    }

    // MARK: Internal

    let value: String
    let type: ChoiceType
    let expected: Int
    let choiceIDs: [UUID]
}

// MARK: Decodable

extension CoordinatorCountTheRightNumberChoiceModel: Decodable {
    public init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.type = try container.decodeIfPresent(ChoiceType.self, forKey: .type) ?? .text
        let number = try container.decode(Int.self, forKey: .number)
        self.expected = try container.decodeIfPresent(Int.self, forKey: .expected) ?? 0
        self.choiceIDs = (0..<number).map { _ in UUID() }
    }

    enum CodingKeys: String, CodingKey {
        case value
        case type
        case number
        case expected
    }
}
