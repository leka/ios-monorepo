// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Navigation {
    enum Category: Hashable, Identifiable, CaseIterable {
        case home
        case search
        case curriculums
        case activities
        case stories
        case gamepads
        case caregivers
        case carereceivers

        // ? DEVELOPER_MODE
        case allPublishedActivities
        case allDraftActivities
        case allTemplateActivities
        case rasterImageList
        case vectorImageList
        case news
        case resources

        // MARK: Internal

        var id: Self { self }
    }
}
