// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import SwiftUI

// MARK: - SavedStory

public struct SavedStory: Hashable {
    // MARK: Public

    public var id: String?
    public var caregiverID: String
    public var createdAt: Date

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case caregiverID = "caregiver_id"
        case createdAt = "created_at"
    }
}
