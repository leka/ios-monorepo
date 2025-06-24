// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - TTSGameplayCoordinatorProtocol

public protocol TTSGameplayCoordinatorProtocol {
    var uiModel: CurrentValueSubject<TTSUIModel, Never> { get }
    var validationEnabled: CurrentValueSubject<Bool?, Never> { get }
    var validation: NewExerciseOptions.Validation { get }
    func processUserSelection(choiceID: UUID)
    func validateUserSelection()
}
