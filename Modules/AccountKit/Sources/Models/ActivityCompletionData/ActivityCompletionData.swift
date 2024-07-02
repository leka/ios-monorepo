// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public struct ActivityCompletionData: Hashable, ActivityCompletionDataDocument {
    // MARK: Public

    public var id: String?
    public var rootOwnerUid: String
    public var caregiverID: String
    public var carereceiverIDs: [String]
    public var startTimestamp: Date?
    public var endTimestamp: Date?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case caregiverID = "caregiver_id"
        case carereceiverIDs = "carereceiver_ids"
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
    }
}
