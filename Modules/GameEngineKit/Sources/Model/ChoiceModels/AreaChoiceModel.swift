// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct AreaChoiceModel : ChoiceModelProtocol {
    public let id: UUID = UUID()
    public let item: String
    public let type: ChoiceDataType
    public var status: ChoiceState
    public var area: String

    public init(item: String, type: ChoiceDataType, status: ChoiceState = .notSelected, area: String) {
        self.item = item
        self.type = type
        self.status = status
        self.area = area
    }
}

extension AreaChoiceModel : Equatable, Comparable {
    public static func < (lhs: AreaChoiceModel, rhs: AreaChoiceModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }
}


