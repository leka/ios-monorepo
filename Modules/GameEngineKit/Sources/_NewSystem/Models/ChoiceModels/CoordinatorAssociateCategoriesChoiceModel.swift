// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CoordinatorAssociateCategoriesChoiceModel

// swiftlint:disable:next type_name
public struct CoordinatorAssociateCategoriesChoiceModel {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, category: AssociateCategory?, type: ChoiceType = .text) {
        self.id = id
        self.value = value
        self.category = category
        self.type = type
    }

    // MARK: Internal

    let id: UUID
    let value: String
    let category: AssociateCategory?
    let type: ChoiceType
}
