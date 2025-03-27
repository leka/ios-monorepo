// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - MemoryGameplayCoordinatorProtocol

public protocol MemoryGameplayCoordinatorProtocol {
    var uiModel: CurrentValueSubject<MemoryUIModel, Never> { get }
    func processUserSelection(choiceID: UUID)
}
