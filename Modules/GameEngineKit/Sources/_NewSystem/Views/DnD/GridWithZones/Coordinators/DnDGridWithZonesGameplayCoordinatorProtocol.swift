// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// swiftlint:disable:next type_name
public protocol DnDGridWithZonesGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<DnDUIChoices, Never> { get }
    var uiDropZones: [DnDDropZoneNode] { get }
    func onTouch(_ event: DnDTouchEvent, choice: DnDAnswerNode, destination: DnDDropZoneNode?)
}
