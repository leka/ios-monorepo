// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import Yams

// MARK: - CategoryResources

// swiftlint:disable nesting

public struct CategoryResources: CategoryProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.l10n = try container.decode([Category.LocalizedDetails].self, forKey: .l10n)
        self.content = try container.decode([Category.ResourcePayload].self, forKey: .content)
    }

    // MARK: Public

    public var l10n: [Category.LocalizedDetails]
    public var content: [Category.ResourcePayload]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case l10n
        case content
    }
}

public extension Category {
    struct Resource: Codable, Identifiable {
        // MARK: Lifecycle

        public init(icon: String = "",
                    title: String = "",
                    description: String = "",
                    value: String = "",
                    type: String = "")
        {
            self.icon = icon
            self.title = title
            self.description = description
            self.value = value
            self.type = ResourceType(rawValue: type) ?? .file
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.icon = try container.decode(String.self, forKey: .icon)
            self.title = try container.decode(String.self, forKey: .title)
            self.description = try container.decode(String.self, forKey: .description)
            self.value = try container.decode(String.self, forKey: .value)
            let typeString = try container.decode(String.self, forKey: .type)
            self.type = ResourceType(rawValue: typeString) ?? .file
        }

        // MARK: Public

        public let id = UUID()
        public var icon: String
        public let title: String
        public let description: String
        public let value: String
        public let type: ResourceType

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case icon
            case title
            case description
            case value
            case type
        }
    }

    enum ResourceType: String, Codable {
        case file
        case video
        case link
    }

    struct ResourcePayload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.localizedResources = try container.decode([Category.LocalizedResources].self, forKey: .localizedResources)

            if let localizedResources = self.localizedResources {
                let availableLocales = localizedResources.map(\.locale)

                let currentLocale = availableLocales.first(where: {
                    $0.language.languageCode == LocalizationKit.l10n.language
                }) ?? Locale(identifier: "en_US")

                self.resource = self.localizedResources?.first(where: { $0.locale == currentLocale })?.details ?? Category.Resource()
            } else {
                self.resource = Category.Resource()
            }
        }

        // MARK: Public

        public let resource: Resource

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case localizedResources = "resource"
        }

        private let localizedResources: [LocalizedResources]?
    }

    struct LocalizedResources: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.details = try container.decode(Resource.self, forKey: .details)
        }

        // MARK: Public

        public let locale: Locale
        public let details: Resource

        // MARK: Private

        private enum CodingKeys: CodingKey {
            case locale
            case details
        }
    }
}

// swiftlint:enable nesting
