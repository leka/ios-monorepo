// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public enum DropZone: Int {
    case none = -1
    case first = 0
    case second = 1
}

public struct DragAndDropChoiceModel: DataModelProtocol {
    public let id: UUID = UUID()
    public let value: String
    public let type: ChoiceDataType
    public var status: ChoiceState
    public var dropZoneName: String

    public init(value: String, type: ChoiceDataType, status: ChoiceState = .notSelected, dropZone: DropZone = .none) {
        self.value = value
        self.type = type
        self.status = status
        self.dropZoneName = dropZone
    }
}

extension DragAndDropChoiceModel: Comparable {
    public static func < (lhs: DragAndDropChoiceModel, rhs: DragAndDropChoiceModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }
}
