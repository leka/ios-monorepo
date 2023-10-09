// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplayError: GameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    public func process(choice: ChoiceModel) {
        // Nothing to do
    }
}
