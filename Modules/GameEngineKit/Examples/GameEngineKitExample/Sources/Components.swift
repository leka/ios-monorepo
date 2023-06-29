// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

let listThreeChoices = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .text),
    ChoiceViewModel(item: "yellow", type: .color),
]

let listSixChoices = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .text),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "pink", type: .text),
]

public let dataThree1 = StandardGameplayData(
    choices: listThreeChoices,
    rightAnswers: [listThreeChoices[1]])

public let dataThree2 = StandardGameplayData(
    choices: listThreeChoices,
    rightAnswers: [listThreeChoices[1], listThreeChoices[2]])

public let dataThree3 = StandardGameplayData(
    choices: listThreeChoices,
    rightAnswers: [listThreeChoices[1], listThreeChoices[2]],
    answersNumber: 2
)

public let dataSix1 = StandardGameplayData(
    choices: listSixChoices,
    rightAnswers: [listSixChoices[2]])

public let dataSix2 = StandardGameplayData(
    choices: listSixChoices,
    rightAnswers: [listSixChoices[1], listSixChoices[3], listSixChoices[4]])

public let dataSix3 = StandardGameplayData(
    choices: listSixChoices,
    rightAnswers: [listSixChoices[1], listSixChoices[3], listSixChoices[4]],
    answersNumber: 2
)

public var oneAnswerThreeInlineGameplay = gameplaySelector(type: .selectTheRightAnswer, data: dataThree1)
public var allAnswersThreeInlineGameplay = gameplaySelector(type: .selectAllRightAnswers, data: dataThree2)
public var someAnswersThreeInlineGameplay = gameplaySelector(type: .selectSomeRightAnswers, data: dataThree3)

public var oneAnswerSixGridGameplay = gameplaySelector(type: .selectTheRightAnswer, data: dataSix1)
public var allAnswersSixGridGameplay = gameplaySelector(type: .selectAllRightAnswers, data: dataSix2)
public var someAnswersSixGridGameplay = gameplaySelector(type: .selectSomeRightAnswers, data: dataSix3)
