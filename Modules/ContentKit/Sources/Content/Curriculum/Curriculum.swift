// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UIKit

// MARK: - Curriculum

public struct Curriculum: Identifiable {
    // MARK: Lifecycle

    public init?(id: String) {
        if let curriculum = ContentKit.allCurriculums[id] {
            self = curriculum
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
    public let tags: [Tag]

    public let locales: [Locale]
    public let l10n: [LocalizedDetails]

    public let activities: [String]

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
        case tags
        case locales
        case l10n
        case activities
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
