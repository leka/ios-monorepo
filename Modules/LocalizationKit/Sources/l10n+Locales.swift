// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

public extension l10n {
    static var locale: Locale = .current

    static var language: Locale.LanguageCode = locale.language.languageCode ?? .english

    static var preferred: Locale.LanguageCode = .init(Bundle.main.preferredLocalizations[0])

    static var availableLocales: [Locale] = [
        .init(identifier: "en_US"),
        .init(identifier: "fr_FR"),
    ]
}
