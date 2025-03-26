// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MemoryUIChoiceModel

public struct MemoryUIChoiceModel: Identifiable {
    // MARK: Lifecycle

    init(id: UUID = UUID(), view: some View = EmptyView(), disabled: Bool = false) {
        self.id = id
        self.view = AnyView(view)
        self.disabled = disabled
    }

    // MARK: Public

    public let id: UUID

    // MARK: Internal

    let view: AnyView
    let disabled: Bool
}

// MARK: - MemoryUIModel

public struct MemoryUIModel {
    static let zero = MemoryUIModel(choices: [])

    var choices: [MemoryUIChoiceModel]

    func choiceSize(for numberOfChoices: Int) -> CGFloat {
        switch numberOfChoices {
            case 1...2:
                300
            case 3:
                280
            case 4...6:
                240
            case 7...8:
                200
            default:
                200
        }
    }
}
