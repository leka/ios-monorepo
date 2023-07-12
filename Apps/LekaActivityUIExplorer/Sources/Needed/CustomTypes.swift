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
    case danceFreeze = "dance_freeze"
    case hideAndSeek = "hide_and_seek"
}

enum GameLayout: Codable {
    case touch1, touch2, touch3, touch3Inline, touch4, touch4Inline, touch5, touch6
    case soundTouch1, soundTouch2, soundTouch3, soundTouch3Inline, soundTouch4, soundTouch4Inline, soundTouch6
    case basket1, basket2, basket4, basketEmpty
    case colorQuest1, colorQuest2, colorQuest3
    case remoteStandard, remoteArrow
    case xylophone
    case danceFreeze
    case hideAndSeek
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
