// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import LocalizationKit
import SwiftUI

// MARK: - CurationType

public enum CurationType: String, Codable {
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
                String(l10n.CurationType.curriculumLabel.characters)
            case .activity:
                String(l10n.CurationType.activityLabel.characters)
            case .story:
                String(l10n.CurationType.storyLabel.characters)
            case .curation:
                String(l10n.CurationType.curationLabel.characters)
        }
    }
}

// MARK: - l10n.CurationType

extension l10n {
    enum CurationType {
        static let curriculumLabel = LocalizedString("content_kit.curation_type.curriculum_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Curriculum",
                                                     comment: "Label title of 'curriculum' curation type")

        static let activityLabel = LocalizedString("content_kit.curation_type.activity_label",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Activity",
                                                   comment: "Label title of 'activity' curation type")

        static let storyLabel = LocalizedString("content_kit.curation_type.story_label",
                                                bundle: ContentKitResources.bundle,
                                                value: "Story",
                                                comment: "Label title of 'story' curation type")

        static let curationLabel = LocalizedString("content_kit.curation_type.curation_label",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Curation",
                                                   comment: "Label title of 'curation' curation type")
    }
}
