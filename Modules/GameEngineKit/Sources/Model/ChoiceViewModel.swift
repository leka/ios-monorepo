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
    public let color: Color
    public var status: ChoiceViewStatus

    init(color: Color, status: ChoiceViewStatus = .notSelected) {
        self.color = color
        self.status = status
    }

    static public let listThreeChoices: [ChoiceViewModel] = [
        ChoiceViewModel(color: .red),
        ChoiceViewModel(color: .blue),
        ChoiceViewModel(color: .yellow),
    ]

    static public let listSixChoices: [ChoiceViewModel] = [
        ChoiceViewModel(color: .red),
        ChoiceViewModel(color: .blue),
        ChoiceViewModel(color: .green),
        ChoiceViewModel(color: .purple),
        ChoiceViewModel(color: .yellow),
        ChoiceViewModel(color: .pink),
    ]
}
