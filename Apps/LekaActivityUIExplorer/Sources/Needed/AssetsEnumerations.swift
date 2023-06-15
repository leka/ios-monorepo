// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable identifier_name

protocol Previewable {
    var index: Int { get }
    var type: ActivityType { get }
    var preview: String { get }

    func defaults() -> BaseDefaults?
}

extension Previewable where Self: RawRepresentable, RawValue == Int {
    var index: Int { return self.rawValue }
}

enum TouchToSelectPreviews: Int, CaseIterable, Previewable {
    case one, two, three, threeInline, four, fourInline, five, six
    var type: ActivityType { return .touchToSelect }
    var preview: String {
        switch self {
            case .one: return "LayoutTemplate_1"
            case .two: return "LayoutTemplate_2"
            case .three: return "LayoutTemplate_3"
            case .threeInline: return "LayoutTemplate_3_inline"
            case .four: return "LayoutTemplate_4"
            case .fourInline: return "LayoutTemplate_4_inline"
            case .five: return "LayoutTemplate_5"
            case .six: return "LayoutTemplate_6"
        }
    }
    func defaults() -> BaseDefaults? {
        switch self {
            case .one: return TouchToSelect.one
            case .two: return TouchToSelect.two
            case .three: return TouchToSelect.three
            case .threeInline: return TouchToSelect.threeInline
            case .four: return TouchToSelect.four
            case .fourInline: return TouchToSelect.fourInline
            case .five: return TouchToSelect.five
            case .six: return TouchToSelect.six
        }
    }
}

enum ListenThenTouchToSelectPreviews: Int, CaseIterable, Previewable {
    case one, two, three, threeInline, four, fourInline, six
    var type: ActivityType { return .listenThenTouchToSelect }
    var preview: String {
        switch self {
            case .one: return "LayoutTemplate_1"
            case .two: return "LayoutTemplate_2"
            case .three: return "LayoutTemplate_3"
            case .threeInline: return "LayoutTemplate_3_inline"
            case .four: return "LayoutTemplate_4"
            case .fourInline: return "LayoutTemplate_4_inline"
            case .six: return "LayoutTemplate_6"
        }
    }
    func defaults() -> BaseDefaults? {
        switch self {
            case .one: return ListenThenTouchToSelect.one
            case .two: return ListenThenTouchToSelect.two
            case .three: return ListenThenTouchToSelect.three
            case .threeInline: return ListenThenTouchToSelect.threeInline
            case .four: return ListenThenTouchToSelect.four
            case .fourInline: return ListenThenTouchToSelect.fourInline
            case .six: return ListenThenTouchToSelect.six
        }
    }
}

enum ColorQuestPreviews: Int, CaseIterable, Previewable {
    case one, two, three
    var type: ActivityType { return .colorQuest }
    var preview: String {
        switch self {
            case .one: return "ColorQuest_1"
            case .two: return "ColorQuest_2"
            case .three: return "ColorQuest_3"
        }
    }
    func defaults() -> BaseDefaults? {
        switch self {
            case .one: return ColorQuest.one
            case .two: return ColorQuest.two
            case .three: return ColorQuest.three
        }
    }
}

enum MiscPreviews: Int, CaseIterable, Previewable {
    case xylophone
    var type: ActivityType { return .xylophone }
    var preview: String {
        switch self {
            case .xylophone: return "xylophoneTemplate"
        }
    }
    func defaults() -> BaseDefaults? {
        switch self {
            case .xylophone: return Misc.xylophone
        }
    }
}

enum RemotePreviews: Int, CaseIterable, Previewable {
    case standard, arrow
    var type: ActivityType { return .remote }
    var preview: String {
        switch self {
            case .standard: return "remoteStandard"
            case .arrow: return "remoteArrow"
        }
    }
    func defaults() -> BaseDefaults? {
        switch self {
            case .standard: return Remote.standard
            case .arrow: return Remote.arrow
        }
    }
}

enum DragAndDropPreviews: Int, CaseIterable, Previewable {
    case basket1, basket2, basket4, emptyBasket
    var type: ActivityType { return .dragAndDrop }
    var preview: String {
        switch self {
            case .basket1: return "basket_1"
            case .basket2: return "basket_2"
            case .basket4: return "basket_4"
            case .emptyBasket: return "empty_basket"
        }
    }
    func defaults() -> BaseDefaults? {
        return DragAndDrop.basket
    }
}

// swiftlint:enable identifier_name
