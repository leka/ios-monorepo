// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

protocol ExerciseSharedDataProtocol {
    var didComplete: PassthroughSubject<Void, Never> { get }
}
