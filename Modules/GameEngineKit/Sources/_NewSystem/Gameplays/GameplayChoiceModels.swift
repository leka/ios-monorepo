// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - GameplayChoiceState

enum GameplayChoiceState {
    case idle
    case rightAnswer
    case wrongAnswer
}

// MARK: - GameplayChoiceModelProtocol

protocol GameplayChoiceModelProtocol: Identifiable {
    associatedtype ChoiceType

    var id: String { get }
    var choice: ChoiceType { get }
    var state: GameplayChoiceState { get set } // .selected, .idle, .rightAnswer, .wrongAnswer
}
