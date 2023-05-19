// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable identifier_name

protocol Previewable {
    var index: Int { get }
    var type: ActivityType { get }
    var defaults: BaseDefaults { get }
    var preview: String { get }
}

extension Previewable where Self: RawRepresentable, RawValue == Int {
    var index: Int { return self.rawValue }
}

enum TouchToSelectPreviews: Int, CaseIterable, Previewable {
    case one, two, three, threeInline, four, fourInline, five, six
    var type: ActivityType { return .touchToSelect }
    var defaults: BaseDefaults {
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
}

enum ListenThenTouchToSelectPreviews: Int, CaseIterable, Previewable {
    case one, two, three, threeInline, four, fourInline, six
    var type: ActivityType { return .listenThenTouchToSelect }
    var defaults: BaseDefaults {
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
}

enum ColorQuestPreviews: Int, CaseIterable, Previewable {
    case one, two, three
    var type: ActivityType { return .colorQuest }
    var defaults: BaseDefaults {
        switch self {
            case .one: return ColorQuest.one
            case .two: return ColorQuest.two
            case .three: return ColorQuest.three
        }
    }
    var preview: String {
        switch self {
            case .one: return "ColorQuest_1"
            case .two: return "ColorQuest_2"
            case .three: return "ColorQuest_3"
        }
    }
}

enum MiscPreviews: Int, CaseIterable, Previewable {
    case xylophone
    var type: ActivityType { return .xylophone }
    var defaults: BaseDefaults {
        switch self {
            case .xylophone: return Misc.xylophone
        }
    }
    var preview: String {
        switch self {
            case .xylophone: return "xylophoneTemplate"
        }
    }
}

enum RemotePreviews: Int, CaseIterable, Previewable {
    case standard
    var type: ActivityType { return .remote }
    var defaults: BaseDefaults {
        switch self {
            case .standard: return Remote.standard
        }
    }
    var preview: String {
        switch self {
            case .standard: return "remoteStandard"
        }
    }
}

// swiftlint:enable identifier_name
