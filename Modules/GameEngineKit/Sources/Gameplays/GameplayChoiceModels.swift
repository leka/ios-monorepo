// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - kDefaultGradingTable

typealias GradingLUT = [Int: [Int: Int]]

let kGradingLUTDefault: GradingLUT = [
    1: [1: 1],
    2: [1: 1, 2: 2],
    3: [1: 1, 2: 2, 3: 3],
    4: [1: 2, 2: 2, 3: 3, 4: 4],
    5: [1: 2, 2: 3, 3: 3, 4: 4, 5: 5],
    6: [1: 3, 2: 3, 3: 4, 4: 4, 5: 5, 6: 6],
]

let kGradingLUTRightOrder: GradingLUT = [
    1: [1: 1],
    2: [2: 1],
    3: [3: 1],
    4: [4: 2],
    5: [5: 2],
    6: [6: 2],
]

let kGradingLUTMemory: GradingLUT = [
    2: [1: 1],
    4: [1: 1, 2: 4],
    6: [1: 1, 2: 6, 3: 6],
    8: [1: 1, 2: 8, 4: 8],
]

// MARK: - GameplayChoiceState

public enum GameplayChoiceState {
    case idle
    case selected
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
