// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol GameplayProtocol: ObservableObject {
    var choices: CurrentValueSubject<[ChoiceViewModel], Never> { get set }
    var state: CurrentValueSubject<GameplayState, Never> { get set }

    func setup()
    func process(choice: ChoiceViewModel)
}
