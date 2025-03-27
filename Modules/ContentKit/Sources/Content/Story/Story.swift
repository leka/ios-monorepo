// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UIKit
import Yams

// MARK: - Story

// swiftlint:disable nesting

public struct Story: Decodable, Identifiable {
    // MARK: Lifecycle

    public init?(id: String) {
        if let story = ContentKit.allStories.first(where: { $0.id == id }) {
            self = story
        } else {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.lastEditedAt = try container.decode(Date.self, forKey: .lastEditedAt)
        self.status = try container.decode(Status.self, forKey: .status)

        self.authors = try container.decode([String].self, forKey: .authors)
        self.skills = try container.decode([String].self, forKey: .skills)
        self.hmi = try container.decode([String].self, forKey: .hmi)
        self.types = try container.decode([String].self, forKey: .types)
        self.tags = try container.decode([String].self, forKey: .tags)

        let localeStrings = try container.decode([String].self, forKey: .locales)
        self.locales = localeStrings.compactMap { Locale(identifier: $0) }
        self.l10n = try container.decode([LocalizedDetails].self, forKey: .l10n)

        self.pages = try container.decode([Page].self, forKey: .pages)
    }

    // MARK: Public

    public let uuid: String
    public let name: String
    public let createdAt: Date
    public let lastEditedAt: Date
    public let status: Status

    public let authors: [String] // TODO: (@ladislas) - implement authors
    public let skills: [String] // TODO: (@ladislas) - implement skills
    public let hmi: [String] // TODO: (@ladislas) - implement hmi
    public let types: [String] // TODO: (@ladislas) - implement types
    public let tags: [String] // TODO: (@ladislas) - implement tags

    public let locales: [Locale]
    public let l10n: [LocalizedDetails]

    public var pages: [Page]

    public var id: String { self.uuid }
    public var languages: [Locale.LanguageCode] { self.locales.compactMap(\.language.languageCode) }

    public var details: Details {
        self.details(in: LocalizationKit.l10n.language)
    }

    public func details(in language: Locale.LanguageCode) -> Details {
        guard let details = self.l10n.first(where: { $0.language == language })?.details else {
            logCK.error("No details found for language \(language)")
            fatalError("💥 No details found for language \(language)")
        }

        return details
    }

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
        case status
        case authors
        case skills
        case hmi
        case types
        case tags
        case locales
        case l10n
        case pages
    }
}

// MARK: Story.Status

public extension Story {
    enum Status: String, Decodable {
        case draft
        case published
    }
}

// MARK: Story.LocalizedDetails

public extension Story {
    struct LocalizedDetails: Decodable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let localeString = try container.decode(String.self, forKey: .locale)
            self.locale = Locale(identifier: localeString)

            self.details = try container.decode(Story.Details.self, forKey: .details)
        }

        // MARK: Public

        public let locale: Locale
        public let details: Details

        public var language: Locale.LanguageCode { self.locale.language.languageCode! }

        // MARK: Private

        private enum CodingKeys: CodingKey {
            case locale
            case details
        }
    }
}

// MARK: Story.Details

public extension Story {
    struct Details: Decodable {
        // MARK: Public

        public let icon: String
        public let title: String
        public let subtitle: String?
        public let shortDescription: String
        public let description: String
        public let instructions: String

        public var iconImage: UIImage {
            UIImage(named: "\(self.icon).story.icon.png", in: .module, with: nil)
                ?? UIImage(named: "placeholder.activity.icon.png", in: .module, with: nil)!
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case icon
            case title
            case subtitle
            case shortDescription = "short_description"
            case description
            case instructions
        }
    }
}

// MARK: Hashable

extension Story: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: Equatable

extension Story: Equatable {
    public static func == (lhs: Story, rhs: Story) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

// swiftlint:enable nesting
