// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// MARK: - ExerciseSharedDataProtocol

public protocol ExerciseCompletionObservable {
    var didComplete: PassthroughSubject<Void, Never> { get }
}
