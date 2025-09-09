// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - Curriculum

extension Curriculum: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.lastEditedAt = try container.decode(Date.self, forKey: .lastEditedAt)
        self.status = try container.decode(Status.self, forKey: .status)

        let authorIDs = try container.decode([String].self, forKey: .authors)
        self.authors = authorIDs.compactMap { Authors.authors(id: $0) }
        let skillsIDs = try container.decode([String].self, forKey: .skills)
        self.skills = skillsIDs.compactMap { Skills.skill(id: $0) }
        let hmiIDs = try container.decode([String].self, forKey: .hmi)
        self.hmi = hmiIDs.compactMap { HMI.hmi(id: $0) }
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
