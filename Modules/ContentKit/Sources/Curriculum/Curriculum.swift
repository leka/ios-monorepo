// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UIKit

// MARK: - Curriculum

public struct Curriculum: Decodable, Identifiable {
    // MARK: Lifecycle

    public init?(id: String) {
        if let curriculum = ContentKit.allCurriculums.first(where: { $0.id == id }) {
            self = curriculum
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
        let skillsIDs = try container.decode([String].self, forKey: .skills)
        self.skills = skillsIDs.compactMap { Skills.skill(id: $0) }
        self.hmi = try container.decode([String].self, forKey: .hmi)
        let tagsIDs = try container.decode([String].self, forKey: .tags)
        self.tags = tagsIDs.compactMap { Tags.tag(id: $0) }

        let localeStrings = try container.decode([String].self, forKey: .locales)
        self.locales = localeStrings.compactMap { Locale(identifier: $0) }
        self.l10n = try container.decode([LocalizedDetails].self, forKey: .l10n)

        self.activities = try container.decode([String].self, forKey: .activities).compactMap {
            $0.split(separator: "-")
                .last?
                .trimmingCharacters(in: .whitespaces)
        }
    }

    // MARK: Public

    public let uuid: String
    public let name: String
    public let createdAt: Date
    public let lastEditedAt: Date
    public let status: Status

    public let authors: [String] // TODO: (@ladislas) - implement authors
    public let skills: [Skill]
    public let hmi: [String] // TODO: (@ladislas) - implement hmi
    public let tags: [Tag]

    public let locales: [Locale]
    public let l10n: [LocalizedDetails]

    public let activities: [String] // TODO: (@ladislas) - implement activities

    public var id: String { self.uuid }
    public var languages: [Locale.LanguageCode] { self.locales.compactMap(\.language.languageCode) }

    public var details: Details {
        self.details(in: LocalizationKit.l10n.language)
    }

    public func details(in language: Locale.LanguageCode) -> Details {
        guard let details = self.l10n.first(where: { $0.language == language })?.details else {
            log.error("No details found for language \(language)")
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
        case tags
        case locales
        case l10n
        case activities
    }
}

// MARK: Curriculum.Status

public extension Curriculum {
    enum Status: String, Decodable {
        case draft
        case published
        case template
    }
}

// MARK: Curriculum.LocalizedDetails

public extension Curriculum {
    struct LocalizedDetails: Decodable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let localeString = try container.decode(String.self, forKey: .locale)
            self.locale = Locale(identifier: localeString)

            self.details = try container.decode(Curriculum.Details.self, forKey: .details)
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

// MARK: Curriculum.Details

public extension Curriculum {
    struct Details: Decodable {
        // MARK: Public

        public let icon: String
        public let title: String
        public let subtitle: String?
        public let abstract: String
        public let description: String

        // TODO: (@ladislas) use string path instead
        public var iconImage: UIImage {
            UIImage(named: "\(self.icon).curriculum.icon.png", in: .module, with: nil)
                ?? UIImage(named: "placeholder.curriculum.icon.png", in: .module, with: nil)!
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case icon
            case title
            case subtitle
            case abstract
            case description
        }
    }
}

// MARK: Hashable

extension Curriculum: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}

// MARK: Equatable

extension Curriculum: Equatable {
    public static func == (lhs: Curriculum, rhs: Curriculum) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
