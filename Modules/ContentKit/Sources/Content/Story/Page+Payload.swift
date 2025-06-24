// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - PagePayloadProtocol

public protocol PagePayloadProtocol: Decodable {}

// MARK: - ImagePayload

public struct ImagePayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.size = try container.decode(Int.self, forKey: .size)
        self.text = try container.decode(String.self, forKey: .text)
    }

    // MARK: Public

    public let image: String
    public let size: Int
    public let text: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case image
        case size
        case text
    }
}

// MARK: - TextPayload

public struct TextPayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
    }

    // MARK: Public

    public let text: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case text
    }
}

// MARK: - ButtonImagePayload

public struct ButtonImagePayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idle = try container.decode(String.self, forKey: .idle)
        self.pressed = try container.decodeIfPresent(String.self, forKey: .pressed) ?? self.idle
        self.action = try container.decodeIfPresent(Page.Action.self, forKey: .action)
        self.text = try container.decode(String.self, forKey: .text)
    }

    // MARK: Public

    public let idle: String
    public let pressed: String
    public let text: String
    public let action: Page.Action?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case idle
        case pressed
        case text
        case action
    }
}
