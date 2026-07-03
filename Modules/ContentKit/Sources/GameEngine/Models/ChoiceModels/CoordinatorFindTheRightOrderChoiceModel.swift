// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorFindTheRightOrderChoiceModel

public struct CoordinatorFindTheRightOrderChoiceModel: Identifiable, Equatable {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, type: ChoiceType = .text, state: State = .unanswered) {
        self.id = id
        self.value = value
        self.type = type
        self.state = state
    }

    // MARK: Public

    public enum State: String, Codable {
        case unanswered
        case hint
        case answered
    }

    public let id: UUID

    // MARK: Internal

    static let zero = CoordinatorFindTheRightOrderChoiceModel(value: "")

    let value: String
    let type: ChoiceType
    let state: State
}

// MARK: Decodable

extension CoordinatorFindTheRightOrderChoiceModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.type = try container.decodeIfPresent(ChoiceType.self, forKey: .type) ?? .text
        self.state = try container.decodeIfPresent(State.self, forKey: .state) ?? .unanswered

        self.id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case value
        case type
        case state
    }
}
