// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension ActivityCompletionData {
    init(rootOwnerUid: String = "",
         caregiverID: String = "",
         carereceiverID: String = "")
    {
        self.rootOwnerUid = rootOwnerUid
        self.caregiverID = caregiverID
        self.carereceiverID = carereceiverID
    }
}
