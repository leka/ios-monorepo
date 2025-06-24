// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import Version
import Yams

// MARK: - Authors

public class Authors: Codable {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadHMI()
    }

    // MARK: Public

    public static var list: [Author] {
        shared.container.list
    }

    public static func hmi(id: String) -> Author? {
        self.list.first(where: { $0.id == id })
    }

    // MARK: Private

    private struct AuthorsContainer: Codable {
        let list: [Author]
    }

    private static let shared: Authors = .init()

    private let container: AuthorsContainer

    private static func loadHMI() -> AuthorsContainer {
        if let fileURL = Bundle.module.url(forResource: "authors", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(AuthorsContainer.self, from: yamlString)
                return container
            } catch {
                logCK.error("Failed to read YAML file: \(error)")
                return AuthorsContainer(list: [])
            }
        } else {
            logCK.error("hmi.yml not found")
            return AuthorsContainer(list: [])
        }
    }
}

// MARK: - Author

public struct Author: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.visible = try container.decode(Bool.self, forKey: .visible)
        self.name = try container.decode(String.self, forKey: .name)
        self.website = try container.decode(String.self, forKey: .website)
        self.email = try container.decode(String.self, forKey: .email)
        self.professions = try container.decode([String].self, forKey: .professions)

        self.l10n = try container.decode([Author.Localization].self, forKey: .l10n)

        let availableLocales = self.l10n.map(\.locale)

        let currentLocale = availableLocales.first(where: {
            $0.language.languageCode == LocalizationKit.l10n.language
        }) ?? Locale(identifier: "en_US")

        self.description = self.l10n.first(where: { $0.locale == currentLocale })!.description
    }

    // MARK: Public

    public let id: String
    public let visible: Bool
    public let name: String
    public let website: String
    public let email: String
    public let professions: [String]
    public let description: String

    // MARK: Private

    private let l10n: [Localization]
}

// MARK: Author.Localization

public extension Author {
    struct Localization: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.description = try container.decode(String.self, forKey: .description)
        }

        // MARK: Internal

        let locale: Locale
        let description: String
    }
}
