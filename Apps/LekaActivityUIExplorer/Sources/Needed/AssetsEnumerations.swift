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

    var content: String {
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

enum ListenThenTouchToSelectPreviews: Int, CaseIterable, Hashable {
    case one, two, three, threeInline, four, fourInline, six

    var content: String {
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

enum ColorQuestPreviews: Int, CaseIterable, Hashable {
    case one, two, three

    var content: String {
        switch self {
            case .one: return "ColorQuest_1"
            case .two: return "ColorQuest_2"
            case .three: return "ColorQuest_3"
        }
    }
}

enum MiscPreviews: Int, CaseIterable, Hashable {
    case xylophone

    var content: String {
        switch self {
            case .xylophone: return "xylophoneTemplate"
        }
    }
}

enum AnswerButtonsImages: Int, CaseIterable, Hashable {
    case one, two, three, four, five, six, arobase, ampersand, percent, hashtag

    var content: String {
        switch self {
            case .one: return "LayoutTemplate_1"
            case .two: return "LayoutTemplate_2"
            case .three: return "LayoutTemplate_3"
            case .four: return "LayoutTemplate_4"
            case .five: return "LayoutTemplate_5"
            case .six: return "LayoutTemplate_6"
            case .arobase: return "LayoutTemplate_3"
            case .ampersand: return "LayoutTemplate_4"
            case .percent: return "LayoutTemplate_5"
            case .hashtag: return "LayoutTemplate_6"
        }
    }
}

// swiftlint:enable identifier_name
