// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Page

public struct Page: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.background = try container.decode(String.self, forKey: .background)
        self.items = try container.decode([Item].self, forKey: .items)
    }

    // MARK: Public

    public enum ItemType: String, Decodable {
        case image
        case text
        case button
        case activityButton = "activity_button"
    }

    public let background: String
    public let items: [Item]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case background
        case items
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
                case .button:
                    self.payload = try container.decode(ButtonPayload.self, forKey: .payload)
                case .activityButton:
                    self.payload = try container.decode(ActivityButtonPayload.self, forKey: .payload)
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
