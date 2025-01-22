// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// swiftlint:disable:next type_name
public protocol DnDGridWithZonesGameplayCoordinatorProtocol {
    var uiModel: CurrentValueSubject<DnDGridWithZonesUIModel, Never> { get }
    var uiDropZoneModel: DnDGridWithZonesUIDropzoneModel { get }
    func onTouch(_ event: DnDTouchEvent, choiceID: UUID, destinationID: UUID?)
}
