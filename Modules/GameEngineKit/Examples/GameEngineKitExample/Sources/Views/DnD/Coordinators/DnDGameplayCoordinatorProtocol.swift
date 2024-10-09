// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - DnDGameplayCoordinatorProtocol

protocol DnDGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<DnDUIChoices, Never> { get }
    func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDAnswerNode?)
}
