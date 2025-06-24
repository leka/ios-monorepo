// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Navigation {
    enum Category: String, Hashable, Identifiable, CaseIterable {
        // ? Content
        case home
        case explore
        case objectives
        case search
        case educationalGames = "educational_games"
        case stories
        case gamepads

        // ? sharedLibrary
        case sharedLibraryCurriculums = "shared_library_curriculums"
        case sharedLibraryActivities = "shared_library_activities"
        case sharedLibraryStories = "shared_library_stories"
        case sharedLibraryFavorites = "shared_library_favorites"

        // ? Monitoring
        case caregivers
        case carereceivers

        // ? Resources
        case resourcesFirstSteps = "resources_first_steps"
        case resourcesVideo = "resources_video"
        case resourcesDeepDive = "resources_deep_dive"

        // ? DEVELOPER_MODE + TESTFLIGHT_BUILD
        case curationSandbox
        case allPublishedActivities
        case allDraftActivities
        case allTemplateActivities
        case rasterImageList
        case vectorImageList
        case news
        case demo

        // MARK: Internal

        var id: Self { self }
    }
}
