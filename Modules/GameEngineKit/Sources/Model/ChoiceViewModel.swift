// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - HERE -----------------

// import SwiftUI

// public enum ChoiceDataType {
//     case color, image, text
// }

// public enum ChoiceState {
//     case notSelected
//     case selected
//     case playingRightAnimation
//     case playingWrongAnimation
// }

// public struct ChoiceViewModel: Identifiable, Equatable, Comparable {
//     public static func < (lhs: ChoiceViewModel, rhs: ChoiceViewModel) -> Bool {
//         lhs.id.uuidString < rhs.id.uuidString
//     }

//     public let id: UUID = UUID()
//     public let item: String
//     public var type: ChoiceDataType
//     public var status: ChoiceState
//     public var rightAnswer: Bool

//     public init(item: String, type: ChoiceDataType, status: ChoiceState = .notSelected, rightAnswer: Bool = false) {
//         self.item = item
//         self.type = type
//         self.status = status
//         self.rightAnswer = rightAnswer
//     }
// }

// MARK: - HERE -----------------

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

public protocol ChoiceProtocol: Identifiable, Equatable, Comparable {
    var id: UUID { get }
    var item: String { get }
    var type: ChoiceDataType { get }
    var status: ChoiceState { get set }
}

public class ChoiceViewModel: Identifiable, Equatable, Comparable, ChoiceProtocol {
    public static func == (lhs: ChoiceViewModel, rhs: ChoiceViewModel) -> Bool {
        lhs.id.uuidString == rhs.id.uuidString
    }
    
    public static func < (lhs: ChoiceViewModel, rhs: ChoiceViewModel) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }

    public let id: UUID = UUID()
    public let item: String
    public var type: ChoiceDataType
    public var status: ChoiceState
    public var rightAnswer: Bool

    public init(item: String, type: ChoiceDataType, status: ChoiceState = .notSelected, rightAnswer: Bool = false) {
        self.item = item
        self.type = type
        self.status = status
        self.rightAnswer = rightAnswer
    }
}

public class CategoryModel: ChoiceViewModel {
    public let category: String

    public init(item: String, category: String, type: ChoiceDataType, status: ChoiceState = .notSelected) {
        self.category = category
        super.init(item: item, type: type)
        self.type = type
        self.status = status
    }
}
