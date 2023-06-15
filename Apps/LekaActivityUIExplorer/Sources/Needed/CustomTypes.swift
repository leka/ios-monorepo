// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - Localized Custom Type for Yaml Translations
struct LocalizedContent: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
        case frFR = "fr_FR"
    }
    var enUS: String?
    var frFR: String?
}

// MARK: - Activity Types
enum ActivityType: String, Codable {
    case touchToSelect = "touch_to_select"
    case listenThenTouchToSelect = "listen_then_touch_to_select"
    case colorQuest = "color_quest"
    case dragAndDrop = "drag_and_drop"
    case xylophone = "xylophone"
    case remote = "remote_standard"
}

enum GameLayout: Codable {
    case touch_1, touch_2, touch_3, touch_3_inline, touch_4, touch_4_inline, touch_5, touch_6
    case soundTouch_1, soundTouch_2, soundTouch_3, soundTouch_3_inline, soundTouch_4, soundTouch_4_inline, soundTouch_6
    case basket_1, basket_2, basket_4, basket_empty
    case colorQuest_1, colorQuest_2, colorQuest_3
    case remote_1, remote_2
    case xylophone
}

// MARK: - Activity Configurator - Texts's language edition scope
enum Languages: Hashable, CaseIterable {
    case french, english
    var id: Self { self }
    var values: LocalizedContent.CodingKeys {
        switch self {
            case .french: return .frFR
            case .english: return .enUS
        }
    }
}

// MARK: - Game States for UI Translations
enum ResultType {
    case idle, fail, medium, success
}

// MARK: - Alternative Layouts for 3 & 4 answers
enum AlternativeLayout {
    case basic, inline
}
