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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(Status.self, forKey: .status)

        self.authors = try container.decode([String].self, forKey: .authors)
        self.skills = try container.decode([String].self, forKey: .skills)
        self.hmi = try container.decode([String].self, forKey: .hmi)
        self.tags = try container.decode([String].self, forKey: .tags)

        let localeStrings = try container.decode([String].self, forKey: .locales)
        self.locales = localeStrings.compactMap { Locale(identifier: $0) }
        self.l10n = try container.decode([LocalizedDetails].self, forKey: .l10n)

        self.exercisePayload = try container.decode(ExercisesPayload.self, forKey: .exercicesPayload)
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
    public let l10n: [LocalizedDetails]

    public var exercisePayload: ExercisesPayload

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
        case exercicesPayload = "exercises_payload"
    }
}

// MARK: Activity.Status

public extension Activity {
    enum Status: String, Decodable {
        case draft
        case published
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
        public let icon: String
        public let title: String
        public let subtitle: String
        public let description: String
        public let instructions: String

        public var iconImage: UIImage {
            UIImage(named: "\(self.icon).activity.icon.png", in: .module, with: nil)
                ?? UIImage(named: "placeholder.activity.icon.png", in: .module, with: nil)!
        }
    }
}

// MARK: Activity.ExercisesPayload

public extension Activity {
    struct ExercisesPayload: Decodable {
        // MARK: Internal

        let options: Options
        var exerciseGroups: [ExerciseGroup]

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

// swiftlint:enable nesting
