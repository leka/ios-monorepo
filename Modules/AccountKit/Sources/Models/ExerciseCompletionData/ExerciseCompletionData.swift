// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct ExerciseCompletionData: Equatable {
    // MARK: Lifecycle

    public init(
        startTimestamp: Date? = nil,
        endTimestamp: Date? = nil
    ) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
    }

    // MARK: Public

    public var startTimestamp: Date?
    public var endTimestamp: Date?
}
