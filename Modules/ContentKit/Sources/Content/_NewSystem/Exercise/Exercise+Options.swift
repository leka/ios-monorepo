// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - NewExerciseOptions

public struct NewExerciseOptions: Decodable {
    // MARK: Lifecycle

    public init(
        shuffleChoices: Bool = true,
        validation: Validation = .automatic
    ) {
        self.shuffleChoices = shuffleChoices
        self.validation = validation
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.shuffleChoices = try container.decodeIfPresent(Bool.self, forKey: .shuffleChoices) ?? true
        self.validation = try container.decodeIfPresent(Validation.self, forKey: .validation) ?? .automatic
    }

    // MARK: Public

    public enum Validation: Decodable, Equatable {
        case automatic
        case manual
        case manualWithSelectionLimit(minimumToSelect: Int? = nil, maximumToSelect: Int? = nil)

        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let type = try container.decodeIfPresent(TypeValue.self, forKey: .type) ?? .automatic

            switch type {
                case .automatic:
                    self = .automatic

                case .manual:
                    let minimum = try container.decodeIfPresent(Int.self, forKey: .minimumToSelect)
                    let maximum = try container.decodeIfPresent(Int.self, forKey: .maximumToSelect)

                    if minimum != nil || maximum != nil {
                        self = .manualWithSelectionLimit(minimumToSelect: minimum, maximumToSelect: maximum)
                    } else {
                        self = .manual
                    }
            }
        }

        // MARK: Private

        // MARK: Codable

        private enum CodingKeys: String, CodingKey {
            case type
            case minimumToSelect
            case maximumToSelect
        }

        private enum TypeValue: String, Codable {
            case automatic
            case manual
        }
    }

    public let shuffleChoices: Bool
    public let validation: Validation

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case shuffleChoices = "shuffle_choices"
        case validation
    }
}
