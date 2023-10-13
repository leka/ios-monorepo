// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol DragAndDropGameplayProtocol: BaseGameplayProtocol {
    var choices: CurrentValueSubject<[DragAndDropChoiceModel], Never> { get set }
//    var dropZones: CurrentValueSubject<[DragAndDropZoneModel], Never> { get set }

    func process(choice: DragAndDropChoiceModel, dropZoneName: String)
}
