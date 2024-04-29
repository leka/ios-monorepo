// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

// MARK: - ActivityCompletionDataDocument

public protocol ActivityCompletionDataDocument: Codable, Identifiable {
    var id: String? { get set }
    var rootOwnerUid: String { get set }
    var caregiverID: String { get set }
    var carereceiverIDs: [String] { get set }
    var startTimestamp: Date? { get set }
    var endTimestamp: Date? { get set }
    var completionData: String { get set }
}

// MARK: - ActivityCompletionData

public struct ActivityCompletionData: Hashable, ActivityCompletionDataDocument {
    // MARK: Public

    public var id: String?
    public var rootOwnerUid: String
    public var caregiverID: String
    public var carereceiverIDs: [String]
    public var startTimestamp: Date?
    public var endTimestamp: Date?
    public var completionData: String

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case rootOwnerUid = "root_owner_uid"
        case caregiverID = "caregiver_id"
        case carereceiverIDs = "carereceiver_ids"
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
        case completionData = "completion_data"
    }
}
