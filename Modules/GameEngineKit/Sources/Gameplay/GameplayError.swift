// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplayError: GameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceViewModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    public func setup() {
        // Nothing to do
    }

    public func process(choice: ChoiceViewModel) {
        // Nothing to do
    }
}
