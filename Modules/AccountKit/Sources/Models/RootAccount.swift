// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - RootAccount

struct RootAccount: Identifiable, Codable {
    var id: String
    var rootOwnerUid: String
    var createdAt: Date
    var lastEditedAt: Date
}
