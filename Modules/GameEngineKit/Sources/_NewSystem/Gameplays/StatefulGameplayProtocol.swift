// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

protocol StatefulGameplayProtocol {
    var state: CurrentValueSubject<ExerciseState, Never> { get }
}
