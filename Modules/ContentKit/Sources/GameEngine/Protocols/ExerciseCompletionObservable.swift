// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// MARK: - ExerciseCompletionObservable

public protocol ExerciseCompletionObservable {
    var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> { get }
}

// MARK: - ExerciseCompletionData

public struct ExerciseCompletionData {
    // MARK: Lifecycle

    public init(numberOfTrials: Int = 0) {
        self.numberOfTrials = numberOfTrials
    }

    // MARK: Public

    public var numberOfTrials: Int
}
