// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable identifier_name

protocol Previewable {
    var index: Int { get }
    var type: ActivityType { get }
    var content: TemplateDetails { get }
}

extension Previewable where Self: RawRepresentable, RawValue == Int {
    var index: Int { return self.rawValue }
}

enum TouchToSelectPreviews: Int, CaseIterable, Previewable {
    case one, two, three, threeInline, four, fourInline, five, six
    var type: ActivityType { return .touchToSelect }
    var content: TemplateDetails {
        switch self {
            case .one: return TemplateDetails(preview: "LayoutTemplate_1", defaults: TouchToSelect.one)
            case .two: return TemplateDetails(preview: "LayoutTemplate_2", defaults: TouchToSelect.two)
            case .three: return TemplateDetails(preview: "LayoutTemplate_3", defaults: TouchToSelect.three)
            case .threeInline:
                return TemplateDetails(preview: "LayoutTemplate_3_inline", defaults: TouchToSelect.threeInline)
            case .four: return TemplateDetails(preview: "LayoutTemplate_4", defaults: TouchToSelect.four)
            case .fourInline:
                return TemplateDetails(preview: "LayoutTemplate_4_inline", defaults: TouchToSelect.fourInline)
            case .five: return TemplateDetails(preview: "LayoutTemplate_5", defaults: TouchToSelect.five)
            case .six: return TemplateDetails(preview: "LayoutTemplate_6", defaults: TouchToSelect.six)
        }
    }
}

enum ListenThenTouchToSelectPreviews: Int, CaseIterable, Previewable {
    case one, two, three, threeInline, four, fourInline, six
    var type: ActivityType { return .listenThenTouchToSelect }
    var content: TemplateDetails {
        switch self {
            case .one: return TemplateDetails(preview: "LayoutTemplate_1", defaults: ListenThenTouchToSelect.one)
            case .two: return TemplateDetails(preview: "LayoutTemplate_2", defaults: ListenThenTouchToSelect.two)
            case .three: return TemplateDetails(preview: "LayoutTemplate_3", defaults: ListenThenTouchToSelect.three)
            case .threeInline:
                return TemplateDetails(
                    preview: "LayoutTemplate_3_inline", defaults: ListenThenTouchToSelect.threeInline)
            case .four: return TemplateDetails(preview: "LayoutTemplate_4", defaults: ListenThenTouchToSelect.four)
            case .fourInline:
                return TemplateDetails(preview: "LayoutTemplate_4_inline", defaults: ListenThenTouchToSelect.fourInline)
            case .six: return TemplateDetails(preview: "LayoutTemplate_6", defaults: ListenThenTouchToSelect.six)
        }
    }
}

enum ColorQuestPreviews: Int, CaseIterable, Previewable {
    case one, two, three
    var type: ActivityType { return .colorQuest }
    var content: TemplateDetails {
        switch self {
            case .one: return TemplateDetails(preview: "ColorQuest_1", defaults: ColorQuest.one)
            case .two: return TemplateDetails(preview: "ColorQuest_2", defaults: ColorQuest.two)
            case .three: return TemplateDetails(preview: "ColorQuest_3", defaults: ColorQuest.three)
        }
    }
}

enum MiscPreviews: Int, CaseIterable, Previewable {
    case xylophone
    var type: ActivityType { return .xylophone }
    var content: TemplateDetails {
        switch self {
            case .xylophone: return TemplateDetails(preview: "xylophoneTemplate", defaults: Misc.xylophone)
        }
    }
}

// swiftlint:enable identifier_name
