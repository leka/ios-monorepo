// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol GameplayProtocol: ObservableObject {
    var choices: [ChoiceViewModel] { get set }
    var state: GameplayState { get set }

    var choicesPublisher: Published<[ChoiceViewModel]>.Publisher { get }
    var statePublisher: Published<GameplayState>.Publisher { get }

    func process(choice: ChoiceViewModel)
}
