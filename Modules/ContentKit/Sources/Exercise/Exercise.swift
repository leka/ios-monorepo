// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct Exercise: Codable {
    public let instructions: String
    public let type: ExerciseType
    public let interface: Interface
    public let gameplay: Gameplay
    public let payload: ExercisePayload

    public enum Interface: String, Codable {
        case touchToSelect
        case robotThenTouchToSelect
        case listenThenTouchToSelect
        case observeThenTouchToSelect
        case dragAndDrop
    }
}

public enum ExerciseType: String, Codable {
    case selection
    case dragAndDrop
}

public enum UIElementType: String, Codable {
    case image
    case text
    case color
}
