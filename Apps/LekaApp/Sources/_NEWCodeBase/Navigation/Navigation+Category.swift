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
        case sampleActivities
        case carereceivers
        case developerModeImageListPNG

        // MARK: Internal

        var id: Self { self }
    }
}
