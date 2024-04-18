// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import SwiftUI
import Version
import Yams

// MARK: - Avatars

public class Avatars: Codable {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadAvatars()
    }

    // MARK: Public

    public static var categories: [AvatarCategory] {
        shared.container.categories
    }

    public static var version: Version {
        shared.container.version
    }

    public static func avatar(for id: String) -> AvatarCategory? {
        self.categories.first(where: { $0.id == id })
    }

    public static func iconToUIImage(icon: String) -> UIImage {
        guard let image = UIImage(named: "\(icon).avatars.png", in: .module, with: nil) else {
            log.error("No image found for icon \(icon)")
            fatalError("💥 No image found for icon \(icon)")
        }
        return image
    }

    // MARK: Private

    private struct AvatarsContainer: Codable {
        let version: Version
        let categories: [AvatarCategory]
    }

    private static let shared: Avatars = .init()

    private let container: AvatarsContainer

    private static func loadAvatars() -> AvatarsContainer {
        if let fileURL = Bundle.module.url(forResource: "avatars", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(AvatarsContainer.self, from: yamlString)
                return container
            } catch {
                log.error("Failed to read YAML file: \(error)")
                return AvatarsContainer(version: .init(1, 0, 0), categories: [])
            }
        } else {
            log.error("Avatars.yml not found")
            return AvatarsContainer(version: .init(1, 0, 0), categories: [])
        }
    }
}

// MARK: - AvatarCategory

public struct AvatarCategory: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        self.l10n = try container.decode([AvatarCategory.Localization].self, forKey: .l10n)

        let availableLocales = self.l10n.map(\.locale)

        let currentLocale = availableLocales.first(where: {
            $0.language.languageCode == LocalizationKit.l10n.language
        }) ?? Locale(identifier: "en_US")

        self.name = self.l10n.first(where: { $0.locale == currentLocale })!.name
        self.avatars = try container.decode([String].self, forKey: .avatars)
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let avatars: [String]

    // MARK: Private

    private let l10n: [Localization]
}

// MARK: Equatable

extension AvatarCategory: Equatable {
    public static func == (lhs: AvatarCategory, rhs: AvatarCategory) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: Hashable

extension AvatarCategory: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: AvatarCategory.Localization

public extension AvatarCategory {
    struct Localization: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.name = try container.decode(String.self, forKey: .name)
        }

        // MARK: Internal

        let locale: Locale
        let name: String
    }
}
