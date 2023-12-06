// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - FormField

enum FormField {
    case mail, password, confirm, name
}

// MARK: - LocalizedContent

struct LocalizedContent: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
        case frFR = "fr_FR"
    }

    var enUS: String?
    var frFR: String?
}

// MARK: - ResultType

enum ResultType {
    case idle, fail, medium, success
}
