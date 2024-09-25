// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - TTSGameplayCoordinatorProtocol

protocol DNDGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<[DNDChoiceModel], Never> { get }
    func processUserDrop(choice: DNDChoiceModel, target: DNDChoiceModel)
}
