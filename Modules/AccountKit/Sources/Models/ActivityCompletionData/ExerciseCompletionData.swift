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
        numberOfTrials: Int = 0,
        numberOfAllowedTrials: Int = 0
    ) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.numberOfTrials = numberOfTrials
        self.numberOfAllowedTrials = numberOfAllowedTrials
    }

    // MARK: Public

    public var startTimestamp: Date?
    public var endTimestamp: Date?
    public var numberOfTrials: Int
    public var numberOfAllowedTrials: Int
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
