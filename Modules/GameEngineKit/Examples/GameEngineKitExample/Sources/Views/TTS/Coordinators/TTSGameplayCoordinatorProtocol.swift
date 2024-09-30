// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - TTSGameplayCoordinatorProtocol

protocol TTSGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<UIChoices, Never> { get }
    func processUserSelection(choice: TTSChoiceModel)
}
