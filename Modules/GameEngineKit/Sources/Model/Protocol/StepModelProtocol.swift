// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol StepModelProtocol {
    var choices: [ChoiceViewModel] { get set }
    var gameplay: GameplayType { get set }
    var interface: InterfaceType { get set }
}
