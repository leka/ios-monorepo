// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension ActivityCompletionData {
    init(
        id: String = "",
        rootOwnerUid: String = "",
        caregiverID: String = "",
        carereceiverID: String = "",
        startTimestamp: Date?,
        endTimestamp: Date?
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.caregiverID = caregiverID
        self.carereceiverID = carereceiverID
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
    }
}
