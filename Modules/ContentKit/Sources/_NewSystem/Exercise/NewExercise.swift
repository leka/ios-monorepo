// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - NewExercise

public struct NewExercise {
    public let instructions: String?
    public let interface: NewExerciseInterface
    public let gameplay: NewExerciseGameplay?
    public let action: NewExerciseAction?
    public let payload: Data?
}
