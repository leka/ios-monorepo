// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct DragAndDropZoneModel: DataModelProtocol {
    public let id: UUID = UUID()
    public let value: String

    public init(value: String) {
        self.value = value
    }
}

extension DragAndDropZoneModel: Comparable {
    public static func < (lhs: DragAndDropZoneModel, rhs: DragAndDropZoneModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }
}
