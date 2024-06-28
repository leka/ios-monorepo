// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - kDefaultGradingTable

typealias GradingLUT = [Int: [Int: Int]]

// TODO: (@HPezz): Split into several gameplays gradingTables
let kGradingLUTDefault: GradingLUT = [
    1: [1: 1],
    2: [1: 1, 2: 2],
    3: [1: 1, 2: 2, 3: 3],
    4: [1: 2, 2: 2, 3: 3, 4: 4],
    5: [1: 2, 2: 3, 3: 3, 4: 4, 5: 5],
    6: [1: 3, 2: 3, 3: 4, 4: 4, 5: 5, 6: 6],
]

// MARK: - GameplayChoiceState

public enum GameplayChoiceState {
    case idle
    case rightAnswer
    case wrongAnswer
}

// MARK: - GameplayChoiceModelProtocol

protocol GameplayChoiceModelProtocol: Identifiable, Equatable {
    associatedtype ChoiceType

    var id: String { get }
    var choice: ChoiceType { get }
    var state: GameplayChoiceState { get set } // .selected, .idle, .rightAnswer, .wrongAnswer
}
