// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

let threeRawItems = ["red", "blue", "yellow"]
let threeTypes = [DataType.color, DataType.text, DataType.color]

let sixRawItems = ["red", "blue", "yellow", "dummy_1", "yellow", "pink"]
let sixTypes = [DataType.color, DataType.text, DataType.color, DataType.image, DataType.color, DataType.text]

public let listThreeChoices = threeRawItems.map { item in
    ChoiceViewModel(item: item)
}

public let listSixChoices = sixRawItems.map { item in
    ChoiceViewModel(item: item)
}

public let dataThree = Data(
    choices: listThreeChoices,
    rightAnswers: [listThreeChoices[1]],
    types: threeTypes)

public let gameplayOneRightAnswerThreeInlineData = SelectTheRightAnswer(
    choices: dataThree.choices, rightAnswers: dataThree.rightAnswers)

public let oneAnswerThreeInlineVMData = ThreeChoicesInlineVM(
    types: dataThree.types, gameplay: gameplayOneRightAnswerThreeInlineData)

public let dataSix = Data(
    choices: listSixChoices,
    rightAnswers: [listSixChoices[2], listSixChoices[3], listSixChoices[4]],
    types: sixTypes)

public let gameplaySomeRightAnswerSixGridData = SelectSomeRightAnswers(
    choices: dataSix.choices, rightAnswers: dataSix.rightAnswers, rightAnswersToFind: 2)

public let oneAnswerSixGridVM = SixChoicesGridVM(
    types: dataSix.types, gameplay: gameplaySomeRightAnswerSixGridData)
