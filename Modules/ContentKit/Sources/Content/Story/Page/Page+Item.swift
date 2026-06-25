// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Page.Item

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
