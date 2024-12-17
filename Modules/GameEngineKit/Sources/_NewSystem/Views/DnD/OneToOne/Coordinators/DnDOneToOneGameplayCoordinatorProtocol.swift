// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol DnDOneToOneGameplayCoordinatorProtocol {
    var uiModel: CurrentValueSubject<DnDOneToOneUIModel, Never> { get }
    var uiDropZones: [DnDDropZoneNode] { get }
    func setAlreadyOrderedNodes()
    func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode?)
}
