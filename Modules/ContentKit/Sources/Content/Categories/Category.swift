// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

import Foundation
import LocalizationKit

// MARK: - CategoryProtocol

public protocol CategoryProtocol: Decodable {
    var l10n: [ContentCategory.LocalizedDetails] { get }
    var details: ContentCategory.Details { get }
    func details(in language: Locale.LanguageCode) -> ContentCategory.Details
}

public extension CategoryProtocol {
    var details: ContentCategory.Details {
        self.details(in: LocalizationKit.l10n.language)
    }

    func details(in language: Locale.LanguageCode) -> ContentCategory.Details {
        guard let details = self.l10n.first(where: { $0.language == language })?.details else {
            logCK.error("No details found for language \(language)")
            fatalError("💥 No details found for language \(language)")
        }

        return details
    }
}

// MARK: - ContentCategory

public struct ContentCategory {}

// MARK: ContentCategory.Details

public extension ContentCategory {
    struct Details: Decodable {
        // MARK: Public

        public let title: String
        public let subtitle: String
        public let description: String

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case title
            case subtitle
            case description
        }
    }
}

// MARK: ContentCategory.LocalizedDetails

public extension ContentCategory {
    struct LocalizedDetails: Decodable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let localeString = try container.decode(String.self, forKey: .locale)
            self.locale = Locale(identifier: localeString)

            self.details = try container.decode(ContentCategory.Details.self, forKey: .details)
        }

        // MARK: Public

        public let locale: Locale
        public let details: Details

        public var language: Locale.LanguageCode { self.locale.language.languageCode! }

        // MARK: Private

        private enum CodingKeys: CodingKey {
            case locale
            case details
        }
    }
}

// swiftlint:enable nesting
