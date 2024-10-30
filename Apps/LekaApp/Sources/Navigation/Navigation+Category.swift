// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Navigation {
    enum Category: Hashable, Identifiable, CaseIterable {
        // ? Information
        case home
        case search

        // ? Content
        case curriculums
        case educationalGames
        case stories
        case gamepads

        // ? Library
        case libraryCurriculums
        case libraryActivities
        case libraryStories

        // ? Monitoring
        case caregivers
        case carereceivers

        // ? Resources
        case resourcesFirstSteps
        case resourcesVideo
        case resourcesDeepDive

        // ? DEVELOPER_MODE + TESTFLIGHT_BUILD
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
