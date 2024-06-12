// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - ExerciseCompletionData

public struct ExerciseCompletionData: Equatable {
    // MARK: Lifecycle

    public init(
        startTimestamp: Date? = nil,
        endTimestamp: Date? = nil,
        payload: String = ""
    ) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.payload = payload
    }

    // MARK: Public

    public var startTimestamp: Date?
    public var endTimestamp: Date?
    public var payload: String
}

// MARK: Hashable

extension ExerciseCompletionData: Hashable {
    public static func == (lhs: ExerciseCompletionData, rhs: ExerciseCompletionData) -> Bool {
        lhs.startTimestamp == rhs.startTimestamp && lhs.endTimestamp == rhs.endTimestamp && lhs.payload == rhs.payload
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.startTimestamp)
        hasher.combine(self.endTimestamp)
        hasher.combine(self.payload)
    }
}
