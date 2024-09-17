// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Navigation {
    enum Category: Hashable, Identifiable, CaseIterable {
        case home
        case search
        case resourcesFirstSteps
        case resourcesVideo
        case resourcesDeepDive
        case curriculums
        case activities
        case stories
        case gamepads
        case caregivers
        case carereceivers

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
