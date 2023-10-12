// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum ChoiceDataType {
    case color, image, text
}

public enum ChoiceState {
    case notSelected
    case selected
    case rightAnswer
    case wrongAnswer
}

public protocol DataModelProtocol: Identifiable, Equatable {
    var id: UUID { get }
}
