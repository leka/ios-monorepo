// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import LocalizationKit
import SwiftUI

// MARK: - ContentType

public enum ContentType: String, Codable {
    case curriculum
    case activity
    case story
    case curation

    // MARK: Public

    public var icon: String {
        switch self {
            case .curriculum:
                "graduationcap"
            case .activity:
                "dice"
            case .story:
                "text.book.closed"
            case .curation:
                "books.vertical"
        }
    }

    public var label: String {
        switch self {
            case .curriculum:
                String(l10n.ContentType.curriculumLabel.characters)
            case .activity:
                String(l10n.ContentType.activityLabel.characters)
            case .story:
                String(l10n.ContentType.storyLabel.characters)
            case .curation:
                String(l10n.ContentType.curationLabel.characters)
        }
    }
}

// MARK: - l10n.ContentType

extension l10n {
    enum ContentType {
        static let curriculumLabel = LocalizedString("content_kit.content_type.curriculum_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Curriculum",
                                                     comment: "Label title of 'curriculum' content type")

        static let activityLabel = LocalizedString("content_kit.content_type.activity_label",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Activity",
                                                   comment: "Label title of 'activity' content type")

        static let storyLabel = LocalizedString("content_kit.content_type.story_label",
                                                bundle: ContentKitResources.bundle,
                                                value: "Story",
                                                comment: "Label title of 'story' content type")

        static let curationLabel = LocalizedString("content_kit.content_type.curation_label",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Curation",
                                                   comment: "Label title of 'curation' content type")
    }
}
