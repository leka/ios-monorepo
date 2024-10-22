// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension SavedStory {
    init(
        id: String? = nil,
        rootOwnerUid: String = "",
        caregiverID: String
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.caregiverID = caregiverID
        self.createdAt = nil
        self.lastEditedAt = nil
    }
}
