// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable identifier_name

enum TouchToSelectPreviews: Int, CaseIterable, Hashable {
    case one, two, three, threeInline, four, fourInline, five, six

    var content: TemplateDetails {
        switch self {
            case .one: return TemplateDetails(preview: "LayoutTemplate_1", type: .touchToSelect)
            case .two: return TemplateDetails(preview: "LayoutTemplate_2", type: .touchToSelect)
            case .three: return TemplateDetails(preview: "LayoutTemplate_3", type: .touchToSelect)
            case .threeInline: return TemplateDetails(preview: "LayoutTemplate_3_inline", type: .touchToSelect)
            case .four: return TemplateDetails(preview: "LayoutTemplate_4", type: .touchToSelect)
            case .fourInline: return TemplateDetails(preview: "LayoutTemplate_4_inline", type: .touchToSelect)
            case .five: return TemplateDetails(preview: "LayoutTemplate_5", type: .touchToSelect)
            case .six: return TemplateDetails(preview: "LayoutTemplate_6", type: .touchToSelect)
        }
    }
}

enum ListenThenTouchToSelectPreviews: Int, CaseIterable, Hashable {
    case one, two, three, threeInline, four, fourInline, six

    var content: TemplateDetails {
        switch self {
            case .one: return TemplateDetails(preview: "LayoutTemplate_1", type: .listenThenTouchToSelect)
            case .two: return TemplateDetails(preview: "LayoutTemplate_2", type: .listenThenTouchToSelect)
            case .three: return TemplateDetails(preview: "LayoutTemplate_3", type: .listenThenTouchToSelect)
            case .threeInline:
                return TemplateDetails(preview: "LayoutTemplate_3_inline", type: .listenThenTouchToSelect)
            case .four: return TemplateDetails(preview: "LayoutTemplate_4", type: .listenThenTouchToSelect)
            case .fourInline: return TemplateDetails(preview: "LayoutTemplate_4_inline", type: .listenThenTouchToSelect)
            case .six: return TemplateDetails(preview: "LayoutTemplate_6", type: .listenThenTouchToSelect)
        }
    }
}

enum ColorQuestPreviews: Int, CaseIterable, Hashable {
    case one, two, three

    var content: TemplateDetails {
        switch self {
            case .one: return TemplateDetails(preview: "ColorQuest_1", type: .colorQuest)
            case .two: return TemplateDetails(preview: "ColorQuest_2", type: .colorQuest)
            case .three: return TemplateDetails(preview: "ColorQuest_3", type: .colorQuest)
        }
    }
}

enum MiscPreviews: Int, CaseIterable, Hashable {
    case xylophone

    var content: TemplateDetails {
        switch self {
            case .xylophone: return TemplateDetails(preview: "xylophoneTemplate", type: .xylophone)
        }
    }
}

// swiftlint:enable identifier_name
