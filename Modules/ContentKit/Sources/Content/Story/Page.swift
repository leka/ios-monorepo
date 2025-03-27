// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Page

// swiftlint:disable nesting

public struct Page: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.background = try container.decode(String.self, forKey: .background)
        self.localizedPages = try container.decode([LocalizedPage].self, forKey: .localizedPages)
        if let localizedPages = self.localizedPages {
            let availableLocales = localizedPages.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.items = self.localizedPages?.first(where: { $0.locale == currentLocale })?.items ?? []
        } else {
            self.items = []
        }
    }

    // MARK: Public

    public let background: String
    public let items: [Item]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case background
        case localizedPages = "l10n"
    }

    // MARK: Private

    private let localizedPages: [LocalizedPage]?
}

// MARK: Page.ItemType

public extension Page {
    // MARK: Public

    enum ItemType: String, Decodable {
        case image
        case text
        case buttonImage = "button_image"
    }
}

// MARK: Page.LocalizedPage

public extension Page {
    struct LocalizedPage: Decodable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.items = try container.decode([Item].self, forKey: .items)
        }

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case locale
            case items
        }

        let locale: Locale
        let items: [Item]
    }
}

// MARK: Page.Item

public extension Page {
    struct Item: Decodable, Identifiable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try container.decode(ItemType.self, forKey: .type)
            switch self.type {
                case .image:
                    self.payload = try container.decode(ImagePayload.self, forKey: .payload)
                case .text:
                    self.payload = try container.decode(TextPayload.self, forKey: .payload)
                case .buttonImage:
                    self.payload = try container.decode(ButtonImagePayload.self, forKey: .payload)
            }
        }

        // MARK: Public

        public let id = UUID()
        public let type: ItemType
        public let payload: PagePayloadProtocol

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case type
            case payload
        }
    }
}

// MARK: - Page.Item + Equatable

extension Page.Item: Equatable {
    public static func == (lhs: Page.Item, rhs: Page.Item) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Page.Item + Hashable

extension Page.Item: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// swiftlint:enable nesting
