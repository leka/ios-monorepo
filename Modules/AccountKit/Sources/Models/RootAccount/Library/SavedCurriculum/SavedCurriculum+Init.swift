// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension SavedCurriculum {
    init(
        id: String? = nil,
        caregiverID: String
    ) {
        self.id = id
        self.caregiverID = caregiverID
        self.createdAt = Date()
    }
}
