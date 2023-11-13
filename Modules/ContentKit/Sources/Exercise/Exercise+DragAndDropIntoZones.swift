// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

public struct DragAndDropIntoZonesChoice: Codable {
    public let value: String
    public let type: UIElementType
    public let dropZone: DropZone?

    public enum DropZone: String, Codable {
        case zoneA
        case zoneB
    }
}

public struct DragAndDropPayload: Codable {
    public let dropZoneA: DropZoneDetails
    public let dropZoneB: DropZoneDetails?
    public let choices: [DragAndDropIntoZonesChoice]
}

public struct DropZoneDetails: Codable {
    public let value: String
    public let type: UIElementType
}
