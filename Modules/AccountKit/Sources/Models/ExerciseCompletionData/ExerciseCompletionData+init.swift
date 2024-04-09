// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension ExerciseCompletionData {
    init(rootOwnerUid: String = "",
         caregiverID: String = "",
         carereceiverID: String = "",
         numberOfTrials: Int = 0,
         numberOfAllowedTrials: Int = 0)
    {
        self.rootOwnerUid = rootOwnerUid
        self.caregiverID = caregiverID
        self.carereceiverID = carereceiverID
        self.numberOfTrials = numberOfTrials
        self.numberOfAllowedTrials = numberOfAllowedTrials
    }
}
