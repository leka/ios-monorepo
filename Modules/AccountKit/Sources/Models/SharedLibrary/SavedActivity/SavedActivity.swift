// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct SavedActivity: Hashable {
    // MARK: Public

    public var id: String
    public var name: String
    public var caregiverID: String
    public var addedAt: Date
    public var favoritedBy: [String: Date]

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case caregiverID = "caregiver_id"
        case addedAt = "added_at"
        case favoritedBy = "favorited_by"
    }
}
