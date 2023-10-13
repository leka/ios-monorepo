// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct DragAndDropZoneStepModel: StepModelProtocol {
    public var dropZones: [DragAndDropZoneModel]
    public var choices: [DragAndDropChoiceModel]
    public var gameplay: GameplayType
    public var interface: InterfaceType

    public init(
        dropZones: [DragAndDropZoneModel],
        choices: [DragAndDropChoiceModel],
        gameplay: GameplayType,
        interface: InterfaceType
    ) {
        self.dropZones = dropZones
        self.choices = choices
        self.gameplay = gameplay
        self.interface = interface
    }
}
