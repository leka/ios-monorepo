// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - AccountDocument

protocol AccountDocument: Codable, Identifiable {
    var id: String { get set }
    var rootOwnerUid: String { get set }
    var createdAt: Date { get set }
    var lastEditedAt: Date { get set }
}

// MARK: - RootAccount

struct RootAccount: AccountDocument {
    var id: String
    var rootOwnerUid: String
    var createdAt: Date
    var lastEditedAt: Date
}
