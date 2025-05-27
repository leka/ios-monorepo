// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension SavedStory {
    init(
        id: String,
        caregiverID: String,
        favoritedBy: [String: Date] = [:]
    ) {
        self.id = id
        self.caregiverID = caregiverID
        self.addedAt = Date()
        self.favoritedBy = favoritedBy
    }
}
