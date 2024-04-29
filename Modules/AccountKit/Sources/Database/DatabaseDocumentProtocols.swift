// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - DatabaseDocument

public protocol DatabaseDocument: Codable, Identifiable {
    var id: String? { get set }
    var rootOwnerUid: String { get set }
}

// MARK: - AccountDocument

public protocol AccountDocument: DatabaseDocument {
    var createdAt: Date? { get set }
    var lastEditedAt: Date? { get set }
}

// MARK: - ActivityCompletionDataDocument

public protocol ActivityCompletionDataDocument: DatabaseDocument {
    var caregiverID: String { get set }
    var carereceiverIDs: [String] { get set }
    var startTimestamp: Date? { get set }
    var endTimestamp: Date? { get set }
    var completionData: String { get set }
}
