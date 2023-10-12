// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ChoiceModel: DataModelProtocol {
    public let id: UUID = UUID()
    public let value: String
    public let type: ChoiceDataType
    public var status: ChoiceState
    public var isRightAnswer: Bool

    public init(value: String, type: ChoiceDataType, status: ChoiceState = .notSelected, rightAnswer: Bool = false) {
        self.value = value
        self.type = type
        self.status = status
        self.isRightAnswer = rightAnswer
    }
}

extension ChoiceModel: Comparable {
    public static func < (lhs: ChoiceModel, rhs: ChoiceModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }
}
