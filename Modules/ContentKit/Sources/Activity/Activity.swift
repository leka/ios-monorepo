// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import Yams

// MARK: - Activity

public struct Activity: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Allow synthesized Codable conformance to decode the rest
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.authors = try container.decode([String].self, forKey: .authors)
        self.skills = try container.decode([String].self, forKey: .skills)
        self.hmi = try container.decode([String].self, forKey: .hmi)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.status = try container.decode(Status.self, forKey: .status)
        self.gameengine = try container.decode(GameEngine.self, forKey: .gameengine)

        self.l10n = try container.decode([Localization].self, forKey: .l10n)
//        exercises = try container.decode([ExerciseGroup].self, forKey: .exercises)

        let localeStrings = try container.decode([String].self, forKey: .locales)
        self.locales = localeStrings.compactMap { Locale(identifier: $0) }
    }

    // MARK: Public

    public let uuid: String
    public let name: String

    public let status: Status

    public let authors: [String] // TODO: (@ladislas) - implement authors
    public let skills: [String] // TODO: (@ladislas) - implement skills
    public let hmi: [String] // TODO: (@ladislas) - implement hmi
    public let tags: [String] // TODO: (@ladislas) - implement tags

    public let locales: [Locale]
    public let l10n: [Localization]

    public let gameengine: GameEngine

    //    public let exercises: [ExerciseGroup]

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
        case authors
        case skills
        case hmi
        case tags
        case status
        case locales
        case l10n
        case gameengine
//        case exercises
    }
}

// MARK: Activity.Status

public extension Activity {
    enum Status: String, Codable {
        case draft
        case published
    }
}

// MARK: Activity.Localization

public extension Activity {
    struct Localization: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let localeString = try container.decode(String.self, forKey: .locale)
            self.locale = Locale(identifier: localeString)

            self.details = try container.decode(Activity.Details.self, forKey: .details)
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

// MARK: Activity.Details

public extension Activity {
    struct Details: Codable {
        public let icon: String
        public let title: String
        public let subtitle: String
        public let description: String
        public let instructions: String
    }
}

// MARK: - GameEngine

public struct GameEngine: Codable {
    // MARK: Internal

    let shuffleExercises: Bool
    let shuffleSequences: Bool

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case shuffleExercises = "shuffle_exercises"
        case shuffleSequences = "shuffle_sequences"
    }
}

// MARK: - ExerciseGroup

struct ExerciseGroup: Codable {
    let group: [Exercise]
}
