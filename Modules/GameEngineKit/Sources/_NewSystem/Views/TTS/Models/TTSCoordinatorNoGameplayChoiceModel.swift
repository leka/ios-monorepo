// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct TTSCoordinatorNoGameplayChoiceModel {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.type = type
    }

    // MARK: Internal

    let id: String
    let value: String
    let type: ChoiceType
}
