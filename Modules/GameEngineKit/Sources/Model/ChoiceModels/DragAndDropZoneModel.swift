// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct DragAndDropZoneModel: ChoiceModelProtocol {
    public let id: UUID = UUID()
    public let item: String
    public let size: CGSize
    public let hints: Bool
    public var choices: [ChoiceModel]

    public init(item: String, size: CGSize, hints: Bool, choices: [ChoiceModel]) {
        self.item = item
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
