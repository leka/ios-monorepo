// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// TODO(@macteuts): Add real implementation if needed
public enum DragAndDropAssociation {

    public enum Catergory: String, Codable {
        case catA
        case catB
        case catC
    }

    public struct Choice: Codable {
        public let value: String
        public let type: UIElementType
        public let catergory: Catergory?
    }

    public struct Payload: Codable {
        public let choices: [Choice]
    }

}
