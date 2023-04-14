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

// MARK: - Templates Scopes (per activity/group/step || mixed)
enum TemplateSelectionScope {
    case activity, group, step
}

// MARK: - Game States for UI Translations
enum ResultType {
    case idle, fail, medium, success
}

// MARK: - Alternative Layouts for 3 & 4 answers
enum AlternativeLayout {
    case basic, inline, spaced
}
