// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import Version
import Yams

// MARK: - Tags

public class Tags {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadTags()
    }

    // MARK: Public

    public static var allTagsList: [Tag] {
        shared.getAllTags()
    }

    public static var primaryTagsList: [Tag] {
        shared.getMainTags()
    }

    public static func tag(id: String) -> Tag? {
        self.allTagsList.first(where: { $0.id == id })
    }

    public static func getAllSubtags(for tag: Tag) -> [Tag] {
        var allSubtags: [Tag] = [tag]

        func getSubtags(for tag: Tag) -> [Tag] {
            var allSubtags: [Tag] = []

            for subtag in tag.subtags {
                allSubtags.append(subtag)
                allSubtags.append(contentsOf: getSubtags(for: subtag))
            }

            return allSubtags
        }

        allSubtags.append(contentsOf: getSubtags(for: tag))

        return allSubtags
    }

    // MARK: Private

    private struct TagsContainer: Codable {
        let list: [Tag]
    }

    private static let shared: Tags = .init()

    private let container: TagsContainer

    private static func loadTags() -> TagsContainer {
        if let fileURL = Bundle.module.url(forResource: "tags", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(TagsContainer.self, from: yamlString)
                return container
            } catch {
                logCK.error("Failed to read YAML file: \(error)")
                return TagsContainer(list: [])
            }
        } else {
            logCK.error("tags.yml not found")
            return TagsContainer(list: [])
        }
    }

    private func getMainTags() -> [Tag] {
        var tags: [Tag] = []

        for tag in self.container.list {
            tags.append(tag)
        }

        return tags
    }

    private func getAllTags() -> [Tag] {
        var allTags: [Tag] = []

        func getSubtags(for tag: Tag) -> [Tag] {
            var allSubtags: [Tag] = []

            for subtag in tag.subtags {
                allSubtags.append(subtag)
                allSubtags.append(contentsOf: getSubtags(for: subtag))
            }

            return allSubtags
        }

        for tag in self.container.list {
            allTags.append(tag)
            allTags.append(contentsOf: getSubtags(for: tag))
        }

        return allTags
    }
}

// MARK: - Tag

public struct Tag: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        self.l10n = try container.decode([Tag.Localization].self, forKey: .l10n)

        let availableLocales = self.l10n.map(\.locale)

        let currentLocale = availableLocales.first(where: {
            $0.language.languageCode == LocalizationKit.l10n.language
        }) ?? Locale(identifier: "en_US")

        self.name = self.l10n.first(where: { $0.locale == currentLocale })!.name
        self.description = self.l10n.first(where: { $0.locale == currentLocale })!.description
        self.subtags = try container.decode([Tag].self, forKey: .subtags)
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let description: String
    public let subtags: [Tag]

    // MARK: Private

    private let l10n: [Localization]
}

// MARK: Tag.Localization

public extension Tag {
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

// MARK: Hashable

extension Tag: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: Equatable

extension Tag: Equatable {
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
}
