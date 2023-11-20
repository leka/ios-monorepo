// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol SelectionGameplayProtocol: BaseGameplayProtocol {
    var choices: CurrentValueSubject<[ChoiceModel], Never> { get set }

    func process(choice: ChoiceModel)
}
