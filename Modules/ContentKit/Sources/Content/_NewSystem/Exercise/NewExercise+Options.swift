// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - NewExerciseOptions

public struct NewExerciseOptions: Codable {
    // MARK: Lifecycle

    public init(shuffleChoices: Bool = true, validation: Validation = .init()) {
        self.shuffleChoices = shuffleChoices
        self.validation = validation
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? true
        self.validation = try container.decodeIfPresent(Validation.self, forKey: .validation) ?? .init()
    }

    // MARK: Public

    public struct Validation: Codable, Equatable {
        // MARK: Lifecycle

        public init(type: ValidationType = .automatic, minimumToSelect: Int? = nil, maximumToSelect: Int? = nil) {
            self.type = type
            self.minimumToSelect = minimumToSelect
            self.maximumToSelect = maximumToSelect
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.type = try container.decodeIfPresent(ValidationType.self, forKey: .type) ?? .automatic
            self.minimumToSelect = try container.decodeIfPresent(Int.self, forKey: .minimumToSelect)
            self.maximumToSelect = try container.decodeIfPresent(Int.self, forKey: .maximumToSelect)
        }

        // MARK: Public

        public enum ValidationType: String, Codable {
            case automatic
            case manual
        }

        public let type: ValidationType
        public let minimumToSelect: Int?
        public let maximumToSelect: Int?
    }

    public let shuffleChoices: Bool
    public let validation: Validation

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case shuffleChoices = "shuffle_choices"
        case validation
    }
}
