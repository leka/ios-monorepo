// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum DragAndDropIntoZones {

    public enum DropZone: String, Codable {
        case zoneA
        case zoneB

        public struct Details: Codable {
            public let value: String
            public let type: Exercise.UIElementType
        }
    }

    public struct Choice: Codable, DraggableChoice {
        public let value: String
        public let type: Exercise.UIElementType
        public let dropZone: DropZone?
    }

    public struct Payload: Codable {
        public let dropZoneA: DropZone.Details
        public let dropZoneB: DropZone.Details?
        public let choices: [Choice]
    }

}

// swiftlint:enable nesting
