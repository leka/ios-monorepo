// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - ActionThenTTSGameplayCoordinatorProtocol

public protocol ActionThenTTSGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<ActionThenTTSViewUIChoicesWrapper, Never> { get }
    func processUserSelection(choice: ActionThenTTSViewUIChoiceModel)
}
