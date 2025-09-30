// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: Activity.LocalizedDetails

public extension Activity {
    struct LocalizedDetails: Decodable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let localeString = try container.decode(String.self, forKey: .locale)
            self.locale = Locale(identifier: localeString)

            self.details = try container.decode(Activity.Details.self, forKey: .details)
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
