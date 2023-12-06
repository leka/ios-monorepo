// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

public enum HideAndSeek {

    public struct Payload: Codable {

        public struct Instructions: Codable {
            public let textMainInstructions: String
            public let textSubInstructions: String
            public let textButtonOk: String
            public let textButtonRobotFound: String

            enum CodingKeys: String, CodingKey {
                case textMainInstructions = "text_main_instructions"
                case textSubInstructions = "text_sub_instructions"
                case textButtonOk = "text_button_ok"
                case textButtonRobotFound = "text_button_robot_found"
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.textMainInstructions = try container.decode(String.self, forKey: .textMainInstructions)
                self.textSubInstructions = try container.decode(String.self, forKey: .textSubInstructions)
                self.textButtonOk = try container.decode(String.self, forKey: .textButtonOk)
                self.textButtonRobotFound = try container.decode(String.self, forKey: .textButtonRobotFound)
            }
        }

        public let instructions: Instructions

        enum CodingKeys: String, CodingKey {
            case instructions
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.instructions = try container.decode(Instructions.self, forKey: .instructions)
        }
    }
}
