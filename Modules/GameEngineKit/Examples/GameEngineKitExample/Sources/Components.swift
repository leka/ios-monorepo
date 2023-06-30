// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

let listThreeChoicesOneRight = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "yellow", type: .color),
]

let listThreeChoicesTwoRight = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
]

let listSixChoicesOneRight = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "pink", type: .text),
]

let listSixChoicesFourRight = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "purple", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "pink", type: .text, rightAnswer: true),
]

public let dataThree1 = StandardGameplayData(
    choices: listThreeChoicesOneRight
)

public let dataThree2 = StandardGameplayData(
    choices: listThreeChoicesTwoRight
)

public let dataThree3 = StandardGameplayData(
    choices: listThreeChoicesTwoRight,
    answersNumber: 1
)

public let dataSix1 = StandardGameplayData(
    choices: listSixChoicesOneRight
)

public let dataSix2 = StandardGameplayData(
    choices: listSixChoicesFourRight
)

public let dataSix3 = StandardGameplayData(
    choices: listSixChoicesFourRight,
    answersNumber: 3
)

public var oneAnswerThreeInlineGameplay = gameplaySelector(type: .selectTheRightAnswer, data: dataThree1)
public var allAnswersThreeInlineGameplay = gameplaySelector(type: .selectAllRightAnswers, data: dataThree2)
public var someAnswersThreeInlineGameplay = gameplaySelector(type: .selectSomeRightAnswers, data: dataThree3)

public var oneAnswerSixGridGameplay = gameplaySelector(type: .selectTheRightAnswer, data: dataSix1)
public var allAnswersSixGridGameplay = gameplaySelector(type: .selectAllRightAnswers, data: dataSix2)
public var someAnswersSixGridGameplay = gameplaySelector(type: .selectSomeRightAnswers, data: dataSix3)
