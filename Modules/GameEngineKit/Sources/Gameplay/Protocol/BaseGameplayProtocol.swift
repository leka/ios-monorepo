// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol BaseGameplayProtocol {
    var state: CurrentValueSubject<GameplayState, Never> { get set }
}
