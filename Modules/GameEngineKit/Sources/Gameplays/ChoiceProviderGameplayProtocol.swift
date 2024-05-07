// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// MARK: - ChoiceProviderGameplayProtocol

protocol ChoiceProviderGameplayProtocol {
    var choices: CurrentValueSubject<[any GameplayChoiceModelProtocol], Never> { get }
}
