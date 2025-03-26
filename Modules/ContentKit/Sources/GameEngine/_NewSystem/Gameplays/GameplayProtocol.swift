// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// MARK: - GameplayProtocol

protocol GameplayProtocol {
    associatedtype ChoiceType: Identifiable

    var isCompleted: CurrentValueSubject<Bool, Never> { get }
}
