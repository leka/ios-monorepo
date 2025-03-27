// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import Version
import Yams

// MARK: - ActivityTypes

public class ActivityTypes: Codable {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadTypes()
    }

    // MARK: Public

    public static var list: [ActivityType] {
        shared.container.list
    }

    public static func type(id: String) -> ActivityType? {
        self.list.first(where: { $0.id == id })
    }

    // MARK: Private

    private struct TypesContainer: Codable {
        let list: [ActivityType]
    }

    private static let shared: ActivityTypes = .init()

    private let container: TypesContainer

    private static func loadTypes() -> TypesContainer {
        if let fileURL = Bundle.module.url(forResource: "activity_types", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(TypesContainer.self, from: yamlString)
                return container
            } catch {
                logCK.error("Failed to read YAML file: \(error)")
                return TypesContainer(list: [])
            }
        } else {
            logCK.error("activity_types.yml not found")
            return TypesContainer(list: [])
        }
    }
}

// MARK: - ActivityType

public struct ActivityType: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        self.l10n = try container.decode([ActivityType.Localization].self, forKey: .l10n)

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

// MARK: ActivityType.Localization

public extension ActivityType {
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
