// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol StepModelProtocol: ObservableObject {
    var choices: [ChoiceViewModel] { get set }
    var gameplay: GameplayType { get set }
    var answersNumber: Int? { get set }
}
