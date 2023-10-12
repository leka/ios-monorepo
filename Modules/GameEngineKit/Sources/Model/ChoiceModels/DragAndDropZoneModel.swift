// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct DragAndDropZoneModel: ChoiceModelProtocol {
    public let id: UUID = UUID()
    public let value: String
    public let size: CGSize
    public let hints: Bool
    public var choices: [ChoiceModel]

    public init(value: String, size: CGSize, hints: Bool, choices: [ChoiceModel]) {
        self.value = value
        self.size = size
        self.hints = hints
        self.choices = choices
    }
}

extension DragAndDropZoneModel: Comparable {
    public static func < (lhs: DragAndDropZoneModel, rhs: DragAndDropZoneModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }
}
