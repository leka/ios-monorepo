// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - DNDGameplayCoordinatorProtocol

protocol DNDGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<DNDUIChoices, Never> { get }
    func onTouch(_ event: DNDTouchEvent, choice: DNDAnswerNode, destination: DNDAnswerNode?)
}
