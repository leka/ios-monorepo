// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct DragAndDropStepModel: StepModelProtocol {
    public var choices: [ChoiceViewModel]
    public var gameplay: GameplayType
    public var interface: InterfaceType
    public var contexts: [ContextViewModel]

    public init(
        choices: [ChoiceViewModel],
        gameplay: GameplayType,
        interface: InterfaceType,
        contexts: [ContextViewModel]
    ) {
        self.choices = choices
        self.gameplay = gameplay
        self.interface = interface
        self.contexts = contexts
    }
}
