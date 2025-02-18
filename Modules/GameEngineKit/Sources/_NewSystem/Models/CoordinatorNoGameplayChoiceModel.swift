// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct CoordinatorNoGameplayChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let type: ChoiceType
}
