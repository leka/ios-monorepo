//
//  AssetsEnumerations.swift
//  LekaActivityUIExplorer
//
//  Created by Mathieu Jeannot on 9/5/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

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

// Unused for now
// enum AnswerButtonsImages: Int, CaseIterable, Hashable {
//     case one, two, three, four, five, six, arobase, ampersand, percent, hashtag
//
//     var content: String {
//         switch self {
//             case .one: return "LayoutTemplate_1"
//             case .two: return "LayoutTemplate_2"
//             case .three: return "LayoutTemplate_3"
//             case .four: return "LayoutTemplate_4"
//             case .five: return "LayoutTemplate_5"
//             case .six: return "LayoutTemplate_6"
//             case .arobase: return "LayoutTemplate_3"
//             case .ampersand: return "LayoutTemplate_4"
//             case .percent: return "LayoutTemplate_5"
//             case .hashtag: return "LayoutTemplate_6"
//         }
//     }
// }

// swiftlint:enable identifier_name
