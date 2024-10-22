// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - TTSGameplayCoordinatorProtocol

public protocol TTSGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<TTSViewUIChoicesWrapper, Never> { get }
    func processUserSelection(choice: TTSViewUIChoiceModel)
}
