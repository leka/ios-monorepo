// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

public struct ExerciseCompletionData: Equatable, Hashable, Codable {
    // MARK: Public

    @ServerTimestamp public var startTimestamp: Date?
    @ServerTimestamp public var endTimestamp: Date?

    public var rootOwnerUid: String
    public var caregiverID: String
    public var carereceiverID: String
    public var numberOfTrials: Int
    public var numberOfAllowedTrials: Int

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
        case rootOwnerUid = "root_owner_uid"
        case caregiverID = "caregiver_id"
        case carereceiverID = "carereceiver_id"
        case numberOfTrials = "number_of_trials"
        case numberOfAllowedTrials = "number_of_allowed_trials"
    }
}
