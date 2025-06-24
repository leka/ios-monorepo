// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum SharedLibraryItem {
    case activity(SavedActivity)
    case curriculum(SavedCurriculum)
    case story(SavedStory)

    // MARK: Public

    public var id: String {
        switch self {
            case let .activity(activity): activity.id
            case let .curriculum(curriculum): curriculum.id
            case let .story(story): story.id
        }
    }

    public var subCollection: SharedLibrarySubCollection {
        switch self {
            case .activity: .activities
            case .curriculum: .curriculums
            case .story: .stories
        }
    }
}
