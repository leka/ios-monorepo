// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - LekaTextFields type and focus managment

enum FormField {
    case mail, password, confirm, name
}

// MARK: - Localized Custom Type for Yaml Translations

struct LocalizedContent: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
        case frFR = "fr_FR"
    }

    var enUS: String?
    var frFR: String?
}

// MARK: - Game States for UI Translations

enum ResultType {
    case idle, fail, medium, success
}
