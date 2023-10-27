// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

protocol StatefulGameplayProtocol {
    var state: CurrentValueSubject<ExerciseState, Never> { get }
}
