// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - Pairing

// swiftlint:disable nesting

public enum Pairing {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.instructions = try container.decode(Instructions.self, forKey: .instructions)
        }

        // MARK: Public

        public let instructions: Instructions

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case instructions
        }
    }
}

// MARK: - Pairing.Payload.Instructions

public extension Pairing.Payload {
    struct Instructions: Codable {
        // MARK: Lifecycle

        public init(
            textMainInstructions: String, textButtonPlay: String, textButtonPause: String,
            textButtonStop: String
        ) {
            self.textMainInstructions = textMainInstructions
            self.textButtonPlay = textButtonPlay
            self.textButtonPause = textButtonPause
            self.textButtonStop = textButtonStop
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.textMainInstructions = try container.decode(String.self, forKey: .textMainInstructions)
            self.textButtonPlay = try container.decode(String.self, forKey: .textButtonPlay)
            self.textButtonPause = try container.decode(String.self, forKey: .textButtonPause)
            self.textButtonStop = try container.decode(String.self, forKey: .textButtonStop)
        }

        // MARK: Public

        public let textMainInstructions: String
        public let textButtonPlay: String
        public let textButtonPause: String
        public let textButtonStop: String

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case textMainInstructions = "text_main_instructions"
            case textButtonPlay = "text_button_play"
            case textButtonPause = "text_button_pause"
            case textButtonStop = "text_button_stop"
        }
    }
}

// swiftlint:enable nesting
