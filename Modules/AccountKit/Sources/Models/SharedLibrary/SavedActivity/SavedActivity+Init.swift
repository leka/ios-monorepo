// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension SavedActivity {
    init(
        id: String,
        name: String,
        caregiverID: String,
        favoritedBy: [String: Date] = [:]
    ) {
        self.id = id
        self.name = name
        self.caregiverID = caregiverID
        self.addedAt = Date()
        self.favoritedBy = favoritedBy
    }
}
