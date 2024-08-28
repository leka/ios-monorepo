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

let kGradingLUTAnyAnswer: GradingLUT = [
    1: [1: Int.max],
    2: [2: Int.max],
    3: [3: Int.max],
    4: [4: Int.max],
    5: [5: Int.max],
    6: [6: Int.max],
]

// MARK: - GameplayChoiceState

public enum GameplayChoiceState {
    case idle
    case selected
    case rightAnswer
    case wrongAnswer
}

// MARK: - Interactivity

enum Interactivity {
    case editable
    case locked
    case clue
}

// MARK: - GameplayChoiceModelProtocol

protocol GameplayChoiceModelProtocol: Identifiable, Equatable {
    associatedtype ChoiceType

    var id: String { get }
    var choice: ChoiceType { get }
    var state: GameplayChoiceState { get set }
    var interactivity: Interactivity { get set }
}
