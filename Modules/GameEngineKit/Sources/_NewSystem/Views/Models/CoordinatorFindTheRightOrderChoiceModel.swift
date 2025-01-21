// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct CoordinatorFindTheRightOrderChoiceModel: Identifiable, Equatable {
    // MARK: Lifecycle

    public init(id: UUID = UUID(), value: String, type: ChoiceType = .text, alreadyOrdered: Bool = false) {
        self.id = id
        self.value = value
        self.type = type
        self.alreadyOrdered = alreadyOrdered
    }

    // MARK: Public

    public let id: UUID

    // MARK: Internal

    static let zero = CoordinatorFindTheRightOrderChoiceModel(value: "")

    let value: String
    let type: ChoiceType
    let alreadyOrdered: Bool
}
