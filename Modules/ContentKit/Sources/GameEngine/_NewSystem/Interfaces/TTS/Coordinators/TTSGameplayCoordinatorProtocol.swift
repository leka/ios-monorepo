// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - TTSGameplayCoordinatorProtocol

public protocol TTSGameplayCoordinatorProtocol {
    var uiModel: CurrentValueSubject<TTSUIModel, Never> { get }
    var validationState: CurrentValueSubject<ValidationState, Never> { get }
    func processUserSelection(choiceID: UUID)
    func validateUserSelection()
}
