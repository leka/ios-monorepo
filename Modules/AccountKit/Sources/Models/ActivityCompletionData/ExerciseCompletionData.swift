// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - ExerciseCompletionData

public struct ExerciseCompletionData: Equatable {
    // MARK: Lifecycle

    public init(
        startTimestamp: Date? = Date(),
        endTimestamp: Date? = nil
    ) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
    }

    // MARK: Public

    public var startTimestamp: Date?
    public var endTimestamp: Date?
}

// MARK: Hashable

extension ExerciseCompletionData: Hashable {
    public static func == (lhs: ExerciseCompletionData, rhs: ExerciseCompletionData) -> Bool {
        lhs.startTimestamp == rhs.startTimestamp && lhs.endTimestamp == rhs.endTimestamp
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.startTimestamp)
        hasher.combine(self.endTimestamp)
    }
}
