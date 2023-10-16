// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public enum ChoiceDataType {
    case color, image, text
}

public enum ChoiceState {
    case notSelected
    case selected
    case playingRightAnimation
    case playingWrongAnimation
}

public protocol ChoiceProtocol {
    var id: UUID { get }
    var item: String { get }
    var type: ChoiceDataType { get }
    var status: ChoiceState { get set }
}

public struct ChoiceModel: Identifiable, Equatable, Comparable, ChoiceProtocol {
    public static func < (lhs: ChoiceModel, rhs: ChoiceModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }

    public let id: UUID = UUID()
    public let item: String
    public let type: ChoiceDataType
    public var status: ChoiceState
    public var rightAnswer: Bool

    public init(item: String, type: ChoiceDataType, status: ChoiceState = .notSelected, rightAnswer: Bool = false) {
        self.item = item
        self.type = type
        self.status = status
        self.rightAnswer = rightAnswer
    }
}

public struct AssociationChoiceModel: Identifiable, Equatable, Comparable, ChoiceProtocol {
    public static func < (lhs: AssociationChoiceModel, rhs: AssociationChoiceModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }

    public let id: UUID = UUID()
    public let item: String
    public let category: String
    public let type: ChoiceDataType
    public var status: ChoiceState

    public init(item: String, category: String, type: ChoiceDataType, status: ChoiceState = .notSelected) {
        self.item = item
        self.category = category
        self.type = type
        self.status = status
    }
}
