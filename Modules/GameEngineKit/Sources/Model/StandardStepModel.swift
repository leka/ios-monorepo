// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI



public struct StandardStepModel : StepModelProtocol {
    public var choices: [ChoiceViewModel]
    public var gameplay: GameplayType
    public var interface: InterfaceType

    public init(
        choices: [ChoiceViewModel],
        gameplay: GameplayType,
        interface: InterfaceType
    ) {
        self.choices = choices
        self.gameplay = gameplay
        self.interface = interface
    }
}
