// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorAssociateCategoriesChoiceModel

public struct CoordinatorAssociateCategoriesChoiceModel {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, value: String, category: AssociateCategory?, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.category = category
        self.type = type
    }

    // MARK: Internal

    let id: String
    let value: String
    let category: AssociateCategory?
    let type: ChoiceType
}
