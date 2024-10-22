// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - MemoryGameplayCoordinatorProtocol

public protocol MemoryGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<MemoryViewUIChoicesWrapper, Never> { get }
    func processUserSelection(choice: MemoryViewUIChoiceModel)
}
