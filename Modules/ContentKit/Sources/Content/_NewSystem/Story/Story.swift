// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - Story

public struct Story: Identifiable {
    // MARK: Lifecycle

    public init?(id: String) {
        if let story = ContentKit.allStories[id] {
            self = story
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
