// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseFirestore
import RobotKit
import SwiftUI

public struct Carereceiver: AccountDocument, Hashable {
    // MARK: Public

    @ServerTimestamp public var createdAt: Date?
    @ServerTimestamp public var lastEditedAt: Date?

    public var id: String?
    public var rootOwnerUid: String
    public var username: String
    public var avatar: String
    public var reinforcer: UInt8

    public var robotReinforcer: Robot.Reinforcer {
        Robot.Reinforcer(rawValue: self.reinforcer) ?? .rainbow
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case rootOwnerUid = "root_owner_uid"
        case createdAt = "created_at"
        case lastEditedAt = "last_edited_at"
        case username
        case avatar
        case reinforcer
    }
}
