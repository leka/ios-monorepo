// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension RootAccount {
    init(
        id: String = "",
        rootOwnerUid: String = "",
        savedActivities: [SavedActivity] = []
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.savedActivities = savedActivities
    }
}
