// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DNDChoiceModel

struct DNDChoiceModel: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, state: DNDChoiceState = .idle) {
        self.id = id
        self.value = value
        self.state = state
    }

    // MARK: Internal

    let id: String
    let value: String
    let state: DNDChoiceState
}

// MARK: - DNDChoiceState

enum DNDChoiceState: Equatable {
    case idle
    case selected(order: Int? = nil)
    case correct(order: Int? = nil)
}
