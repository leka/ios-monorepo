// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UIKit
import Yams

// MARK: - Activity

// swiftlint:disable nesting

public struct Activity: Decodable, Identifiable {
    // MARK: Lifecycle

    public init?(id: String) {
        if let activity = ContentKit.allActivities[id] {
            self = activity
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
        self.types = try container.decode([String].self, forKey: .types)
        let tagsIDs = try container.decode([String].self, forKey: .tags)
        self.tags = tagsIDs.compactMap { Tags.tag(id: $0) }

        let localeStrings = try container.decode([String].self, forKey: .locales)
        self.locales = localeStrings.compactMap { Locale(identifier: $0) }
        self.l10n = try container.decode([LocalizedDetails].self, forKey: .l10n)

        self.exercisePayload = try container.decode(ExercisesPayload.self, forKey: .exercicesPayload)
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
    public let types: [String] // TODO: (@ladislas) - implement types
    public let tags: [Tag]

    public let locales: [Locale]
    public let l10n: [LocalizedDetails]

    public var curriculums: [String] = []

    public var exercisePayload: ExercisesPayload

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
        case exercicesPayload = "exercises_payload"
    }
}

// MARK: Activity.Status

public extension Activity {
    enum Status: String, Decodable {
        case draft
        case published
        case template
    }
}

// MARK: Activity.LocalizedDetails

public extension Activity {
    struct LocalizedDetails: Decodable {
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
    struct Details: Decodable {
        // MARK: Public

        public let icon: String
        public let title: String
        public let subtitle: String?
        public let shortDescription: String
        public let description: String
        public let instructions: String

        public var iconImage: UIImage {
            UIImage(named: "\(self.icon).activity.icon.png", in: .module, with: nil)
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

// MARK: Activity.ExercisesPayload

public extension Activity {
    struct ExercisesPayload: Decodable {
        // MARK: Public

        public let options: Options
        public var exerciseGroups: [ExerciseGroup]

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case options
            case exerciseGroups = "exercise_groups"
        }
    }
}

public extension Activity.ExercisesPayload {
    struct Options: Decodable {
        // MARK: Public

        public let shuffleExercises: Bool
        public let shuffleGroups: Bool

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case shuffleExercises = "shuffle_exercises"
            case shuffleGroups = "shuffle_groups"
        }
    }

    struct ExerciseGroup: Decodable {
        // MARK: Lifecycle

        public init(exercises: [Exercise]) {
            self.exercises = exercises
        }

        // MARK: Public

        public let exercises: [Exercise]

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case exercises = "group"
        }
    }
}

// MARK: - Activity + Hashable

extension Activity: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: - Activity + Equatable

extension Activity: Equatable {
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

// swiftlint:enable nesting
