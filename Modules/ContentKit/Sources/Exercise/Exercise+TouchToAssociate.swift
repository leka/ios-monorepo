// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// TODO(@ladislas): Add real implementation when needed
public enum TouchToAssociate {
    public enum Category: String, Codable {
        case catA
        case catB
        case catC
    }

    public struct Choice: Codable {
        public let value: String
        public let type: Exercise.UIElementType
        public let category: Category?
    }

    public struct Payload: Codable {
        public let choices: [Choice]
    }
}
