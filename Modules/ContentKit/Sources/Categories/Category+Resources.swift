// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UIKit
import Yams

// MARK: - CategoryResources

// swiftlint:disable nesting

public struct CategoryResources: CategoryProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.l10n = try container.decode([Category.LocalizedDetails].self, forKey: .l10n)
        self.sections = try container.decode([CategoryResources.Section].self, forKey: .content)
    }

    // MARK: Public

    public var l10n: [Category.LocalizedDetails]
    public var sections: [CategoryResources.Section]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case l10n
        case content
    }
}

// MARK: CategoryResources.Section

public extension CategoryResources {
    struct Section: Decodable, Identifiable {
        // MARK: Lifecycle

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.l10n = try container.decode([Category.LocalizedDetails].self, forKey: .l10n)
            self.resources = try container.decode([Category.ResourcePayload].self, forKey: .resources)
        }

        // MARK: Public

        public enum CodingKeys: CodingKey {
            case id
            case l10n
            case resources
        }

        public let id: String

        public let resources: [Category.ResourcePayload]

        public var details: Category.Details {
            self.details(in: LocalizationKit.l10n.language)
        }

        // MARK: Internal

        let l10n: [Category.LocalizedDetails]

        // MARK: Private

        private func details(in language: Locale.LanguageCode) -> Category.Details {
            guard let details = self.l10n.first(where: { $0.language == language })?.details else {
                log.error("No details found for language \(language)")
                fatalError("💥 No details found for language \(language)")
            }

            return details
        }
    }
}

public extension Category {
    struct Resource: Codable, Identifiable {
        // MARK: Lifecycle

        public init(icon: String = "",
                    title: String = "",
                    description: String = "",
                    value: String = "",
                    type: String = "",
                    illustration: String = "")
        {
            self.icon = icon
            self.title = title
            self.description = description
            self.value = value
            self.type = ResourceType(rawValue: type) ?? .file
            self.illustration = illustration
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.icon = try container.decode(String.self, forKey: .icon)
            self.title = try container.decode(String.self, forKey: .title)

            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.value = try container.decode(String.self, forKey: .value)
            let typeString = try container.decode(String.self, forKey: .type)
            self.type = ResourceType(rawValue: typeString) ?? .file
            self.illustration = try container.decodeIfPresent(String.self, forKey: .illustration)
        }

        // MARK: Public

        public let id = UUID()
        public var icon: String
        public let title: String
        public let description: String?
        public let value: String
        public let type: ResourceType
        public let illustration: String?

        public var illustrationImage: UIImage {
            UIImage(named: "\(self.illustration!).resource.icon.png", in: .module, with: nil)!
        }

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case icon
            case title
            case description
            case value
            case type
            case illustration
        }
    }

    enum ResourceType: String, Codable {
        case file
        case video
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
