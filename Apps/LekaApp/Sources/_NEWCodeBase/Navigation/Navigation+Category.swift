// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension Navigation {
    enum Category: Hashable, Identifiable, CaseIterable {
        case news
        case resources
        case curriculums
        case activities
        case remotes
        case caregivers
        case carereceivers

        #if DEVELOPER_MODE
            case allActivities
            case developerModeImageListPNG
        #endif

        // MARK: Internal

        var id: Self { self }
    }
}
