// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

// MARK: - ActivityCompletionData

public struct ActivityCompletionData: Hashable, Codable {
    // MARK: Public

    @ServerTimestamp public var startTimestamp: Date?
    @ServerTimestamp public var endTimestamp: Date?

    public var rootOwnerUid: String
    public var caregiverID: String
    public var carereceiverID: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
        case rootOwnerUid = "root_owner_uid"
        case caregiverID = "caregiver_id"
        case carereceiverID = "carereceiver_id"
    }
}
