// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public enum ChoiceViewStatus {
    case notSelected
    case selected
    case playingRightAnimation
    case playingWrongAnimation
}

public struct ChoiceViewModel: Identifiable, Equatable, Comparable {
    public static func < (lhs: ChoiceViewModel, rhs: ChoiceViewModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }

    public let id: UUID = UUID()
    public let item: String
    public var status: ChoiceViewStatus

    public init(item: String, status: ChoiceViewStatus = .notSelected) {
        self.item = item
        self.status = status
    }
}
