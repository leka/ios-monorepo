// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension SavedStory {
    init(
        id: String? = nil,
        caregiverID: String,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.caregiverID = caregiverID
        self.addedAt = Date()
        self.isFavorite = isFavorite
    }
}
