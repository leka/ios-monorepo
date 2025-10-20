// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UtilsKit

// MARK: - Activity

public struct Activity: Identifiable {
    // MARK: Lifecycle

    public init?(id: String) {
        if let activity = ContentKit.allNewActivities[id] {
            self = activity
        } else {
            return nil
        }
    }

    // MARK: Public

    public let uuid: String
    public let name: String
    public let createdAt: Date
    public let lastEditedAt: Date
    public let status: Status

    public let authors: [Author]
    public let skills: [Skill]
    public let interaction: Interaction
    public let types: [ActivityType]
    public let tags: [Tag]

    public let locales: [Locale]
    public let l10n: [LocalizedDetails]

    public var curriculums: [String] = []
    public let payload: Data

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
}

// MARK: Hashable

extension Activity: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: Equatable

extension Activity: Equatable {
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
