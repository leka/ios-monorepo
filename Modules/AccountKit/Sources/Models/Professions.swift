// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import Version
import Yams

// MARK: - Professions

public struct Professions: Codable {
    // MARK: Lifecycle

    public init() {
        if let fileURL = Bundle.module.url(forResource: "professions", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                self = try YAMLDecoder().decode(Professions.self, from: yamlString)
            } catch {
                log.error("Failed to read YAML file: \(error)")
                self.version = Version(major: 0, minor: 0, patch: 0)
                self.list = []
            }
        } else {
            log.error("professions.yml not found")
            self.version = Version(major: 0, minor: 0, patch: 0)
            self.list = []
        }
    }

    // MARK: Public

    public let version: Version
    public let list: [Profession]
}

// MARK: - Profession

public struct Profession: Codable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        self.l10n = try container.decode([Profession.Localization].self, forKey: .l10n)

        let availableLocales = self.l10n.map(\.locale)

        let currentLocale = availableLocales.first(where: {
            $0.language.languageCode == LocalizationKit.l10n.language
        }) ?? Locale(identifier: "en_US")

        self.name = self.l10n.first(where: { $0.locale == currentLocale })!.name
        self.description = self.l10n.first(where: { $0.locale == currentLocale })!.description
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let description: String

    // MARK: Private

    private let l10n: [Localization]
}

// MARK: Profession.Localization

public extension Profession {
    struct Localization: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.name = try container.decode(String.self, forKey: .name)
            self.description = try container.decode(String.self, forKey: .description)
        }

        // MARK: Internal

        let locale: Locale
        let name: String
        let description: String
    }
}
