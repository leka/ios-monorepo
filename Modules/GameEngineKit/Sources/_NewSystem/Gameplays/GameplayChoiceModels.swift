// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

enum GameplayChoiceState {
    case idle
    case rightAnswer
    case wrongAnswer
}

protocol GameplayChoiceModelProtocol: Identifiable {
    associatedtype ChoiceType

    var id: String { get }
    var choice: ChoiceType { get }
    var state: GameplayChoiceState { get set }  // .selected, .idle, .rightAnswer, .wrongAnswer
}
