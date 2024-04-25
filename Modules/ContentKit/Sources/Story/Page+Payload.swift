// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - PagePayloadProtocol

public protocol PagePayloadProtocol: Codable {}

// MARK: - ImagePayload

public struct ImagePayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.size = try container.decode(Int.self, forKey: .size)
        self.localizedText = try? container.decode([LocalizedText].self, forKey: .localizedText)
        if let localizedText = self.localizedText {
            let availableLocales = localizedText.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.text = self.localizedText?.first(where: { $0.locale == currentLocale })?.value ?? ""
        } else {
            self.text = ""
        }
    }

    // MARK: Public

    public let image: String
    public let size: Int
    public let text: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case image
        case size
        case localizedText = "text"
    }

    // MARK: Private

    private let localizedText: [LocalizedText]?
}

// MARK: - TextPayload

public struct TextPayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.localizedText = try? container.decode([LocalizedText].self, forKey: .localizedText)
        if let localizedText = self.localizedText {
            let availableLocales = localizedText.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.text = self.localizedText?.first(where: { $0.locale == currentLocale })?.value ?? ""
        } else {
            self.text = ""
        }
    }

    // MARK: Public

    public let text: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case localizedText = "text"
    }

    // MARK: Private

    private let localizedText: [LocalizedText]?
}

// MARK: - ButtonPayload

public struct ButtonPayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.pressed = try container.decodeIfPresent(String.self, forKey: .pressed) ?? self.image
        let actionRawValue = try container.decodeIfPresent(String.self, forKey: .action) ?? "none"
        self.action = ActionType(rawValue: actionRawValue) ?? .none
        self.localizedText = try? container.decode([LocalizedText].self, forKey: .localizedText)
        if let localizedText = self.localizedText {
            let availableLocales = localizedText.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.text = self.localizedText?.first(where: { $0.locale == currentLocale })?.value ?? ""
        } else {
            self.text = ""
        }
    }

    // MARK: Public

    public enum ActionType: String, Codable {
        case bootyShake
        case randomColor
        case randomMove
        case reinforcer
        case yellow
        case spin
        case dance
        case none
    }

    public let image: String
    public let pressed: String
    public let text: String
    public let action: ActionType

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case image
        case pressed
        case localizedText = "text"
        case action
    }

    // MARK: Private

    private let localizedText: [LocalizedText]?
}

// MARK: - ActivityButtonPayload

public struct ActivityButtonPayload: PagePayloadProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.activity = try container.decode(String.self, forKey: .activity)
        self.localizedText = try? container.decode([LocalizedText].self, forKey: .localizedText)
        if let localizedText = self.localizedText {
            let availableLocales = localizedText.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.text = self.localizedText?.first(where: { $0.locale == currentLocale })?.value ?? ""
        } else {
            self.text = ""
        }
    }

    // MARK: Public

    public let image: String
    public let text: String
    public let activity: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case image
        case localizedText = "text"
        case activity
    }

    // MARK: Private

    private let localizedText: [LocalizedText]?
}

// MARK: - LocalizedText

struct LocalizedText: Codable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
        self.value = try container.decode(String.self, forKey: .value)
    }

    // MARK: Internal

    let locale: Locale
    let value: String
}
